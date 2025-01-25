FROM python:3.11-slim

# タイムゾーンを設定
ENV TZ=Asia/Tokyo

WORKDIR /app

COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

COPY . .

# デフォルト値を設定（環境変数で上書き可能）
ENV PORT=8080
ENV VERTEX_AI_LOCATION=asia-northeast1
ENV GENERATIVE_MODEL_NAME=gemini-pro

EXPOSE 8080

CMD ["uvicorn", "main:app", "--host", "0.0.0.0", "--port", "8080"]