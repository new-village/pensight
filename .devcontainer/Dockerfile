FROM cirrusci/flutter:latest

# Optional: Locale設定
ENV LANG=C.UTF-8

# Optional: Webデバッグ対応（Chromeのインストールなど）
RUN apt-get update && apt-get install -y \
    curl unzip xz-utils zip libglu1-mesa \
    && apt-get clean

# Flutter環境チェック
RUN flutter doctor
