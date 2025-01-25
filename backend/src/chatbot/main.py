"""FastAPI based chatbot application using Vertex AI."""

import logging
import os
from typing import List, Dict, Optional

from fastapi import FastAPI, HTTPException
from pydantic import BaseModel
import vertexai
from vertexai.generative_models import (
    Content,
    Part,
    GenerativeModel,
    Tool,
    grounding
)

from firestore.store import save_chat_response

# ロガーの設定
logging.basicConfig(
    level=logging.INFO,
    format='%(asctime)s - %(name)s - %(levelname)s - %(message)s'
)
logger = logging.getLogger(__name__)


class ChatRequest(BaseModel):
    """チャットリクエストのスキーマ定義"""
    prompt: str
    chat_history: List[Dict[str, str]] = []


class ChatResponse(BaseModel):
    """チャットレスポンスのスキーマ定義"""
    status: str
    response: str
    prompt: str
    error: Optional[str] = None


def load_system_prompt(file_path: str) -> str:
    with open(file_path, 'r', encoding='utf-8') as f:
        return f.read()



def initialize_vertex_ai() -> GenerativeModel:
    """
    Vertex AIの初期化を行い、GenerativeModelオブジェクトを返す
    
    Returns:
        初期化されたGenerativeModelオブジェクト
    Raises:
        ValueError: 環境変数が設定されていない場合
    """
    project_id = os.environ.get("PROJECT_ID")
    location = os.environ.get("VERTEX_AI_LOCATION")
    model_name = os.environ.get("GENERATIVE_MODEL_NAME")

    if not project_id or not location or not model_name:
        raise ValueError(
            "PROJECT_ID, VERTEX_AI_LOCATION, and GENERATIVE_MODEL_NAME must be set in environment variables"
        )
    
    logger.info(f"Initializing Vertex AI with project={project_id}, locarion={location}")
    vertexai.init(project=project_id, location=location)

    tool = Tool.from_google_search_retrieval(grounding.GoogleSearchRetrieval())
    instruction_path = "prompts/system_prompt1.txt"
    system_instruction = load_system_prompt(instruction_path)   
    
    model = GenerativeModel(
        model_name=model_name,
        system_instruction=system_instruction,
        tools=[tool]
    )
    logger.info(f"Vertex AI GenerativeModel created: {model_name}")
    return model
    


def generate_response(
        model: GenerativeModel,
        prompt: str,
        chat_history: Optional[List[Dict[str, str]]] = None
    ) -> Dict[str, str]:
    """
    プロンプトとチャット履歴から応答を生成する

    Args:
        model (GenerativeModel): 生成モデルのインスタンス
        prompt (str): ユーザーからの入力テキスト
        chat_history (Optional[List[Dict[str, str]]]): 過去のチャット履歴

    Returns:
        Dict[str, Any]: 生成結果の情報を含む辞書
    """
    if chat_history is None:
        chat_history = []

    logger.info(f"Generating response for prompt (truncated to 100 chars): {prompt[:100]}...")
    logger.info(f"Chat history length: {len(chat_history)}")

    # モデルに渡すコンテンツを組み立て
    contents = []
    for message in chat_history:
        role = message.get("role", "user")  # roleが存在しない場合のデフォルト
        content_text = message.get("content", "")
        contents.append(Content(
            role=role,
            parts=[Part.from_text(content_text)]
        ))

    contents.append(Content(
        role="user",
        parts=[Part.from_text(prompt)]
    ))

    logger.debug(f"Generated contents structure: {contents}")

    try:
        logger.info("Calling Vertex AI GenerativeModel...")
        response = model.generate_content(contents=contents)
        logger.info("Successfully generated response")

        result = {
            "status": "success",
            "response": response.text,
            "prompt": prompt
        }

        # Firestore に応答を保存
        save_chat_response(result)
        logger.debug("Chat response saved to Firestore")

        return result

    except Exception as err:
        logger.error(f"Error generating response: {err}", exc_info=True)
        return {
            "status": "error",
            "response": "申し訳ございません。応答の生成に失敗しました。",
            "error": str(err),
            "prompt": prompt
        }


# FastAPIアプリケーション初期化
app = FastAPI(
    title="Chatbot API",
    description="Vertex AIを使用したチャットボットAPI",
    version="1.0.0"
)

try:
    # アプリケーション起動時にモデルを初期化
    generative_model = initialize_vertex_ai()
except Exception as e:
    logger.exception("Failed to initialize Vertex AI model.")
    # 重大エラーがある場合、FastAPIアプリの起動を継続しない設計も検討可能
    raise


@app.post("/chat", response_model=ChatResponse)
async def chat_endpoint(request: ChatRequest) -> ChatResponse:
    """
    チャットエンドポイント

    Args:
        request (ChatRequest): ユーザーからのリクエストデータ

    Returns:
        ChatResponse: 生成した応答を含むレスポンス
    """
    logger.info("Received chat request")
    result = generate_response(
        model=generative_model,
        prompt=request.prompt,
        chat_history=request.chat_history
    )

    if result["status"] == "error":
        logger.error(f"Chat request failed: {result.get('error')}")
        raise HTTPException(status_code=500, detail=result["error"])

    logger.info("Successfully processed chat request")
    return ChatResponse(**result)


@app.get("/health")
async def health_check() -> Dict[str, str]:
    """
    ヘルスチェックエンドポイント

    Returns:
        Dict[str, str]: サーバーの状態を示す簡易情報
    """
    logger.debug("Health check requested")
    return {"status": "healthy"}


# アプリケーション起動時のログ
logger.info("Application startup complete.")