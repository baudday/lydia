lydia-build() {
    printf '\n# Building lydia-gateway...\n\n'
    sleep 1

    docker build --no-cache -t lydia-gateway "$LYDIA_ROOT"
}

lydia-up() {
    lydia up -d
}

lydia-down() {
    lydia down
}

lydia-reset() {
    lydia-down
    lydia-build
    lydia-up
}

lydia-logs() {
    lydia logs -f
}

lydia-run() {
    lydia run gateway "$@"
}

lydia() {
    docker compose -f "$LYDIA_ROOT/docker-compose.yml" "$@"
}

lydia-deploy() {
    echo "Building Flutter web app..."
    cd "$LYDIA_ROOT/lydia_client"
    flutter build web --web-renderer canvaskit --release
    cd "$LYDIA_ROOT"

    echo "Deploying to Cloud Run..."
    gcloud run deploy --source "$LYDIA_ROOT" --update-env-vars JWT_SECRET=$(openssl rand -base64 40)
}

export SCRIPTS_DIR="$LYDIA_ROOT/scripts"

source "$SCRIPTS_DIR/lydia-http.sh"
