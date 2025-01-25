import logging
from firebase_admin import credentials, firestore, initialize_app

logger = logging.getLogger(__name__)

try:
    cred = credentials.Certificate("/app/credentials.json")
    initialize_app(cred)
except ValueError:
    # すでに初期化されている場合はスキップ
    pass

def save_chat_response(response_data: dict) -> None:
    """
    generate_response の結果を Firebase Firestore に保存する

    Args:
        response_data: generate_response から返される辞書
        {
            "status": "success/error",
            "response": "生成されたレスポンステキスト",
            "prompt": "入力されたプロンプト"
        }
    """
    try:
        # タイムスタンプを追加
        response_data["timestamp"] = firestore.SERVER_TIMESTAMP
        
        # Firestoreクライアントの初期化
        db = firestore.client()
        # TODO usersに紐づける
        doc_ref = db.collection('chat_responses').document()
        doc_ref.set(response_data)
        logger.info(f"Successfully saved chat response to Firestore: {doc_ref.id}")
        return True
    except Exception as e:
        logger.error(f"Failed to save chat response to Firestore: {str(e)}", exc_info=True)
        return False