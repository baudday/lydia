lydia-build() {
    local SERVICES="$@"

    if [ -z "$SERVICES" ]; then
        SERVICES="gateway ui"
    fi

    # if services includes gateway
    if [[ "$SERVICES" == *"gateway"* ]]; then
        printf '\n# Building Gateway...\n\n'
        sleep 1

        docker build --no-cache -t lydia-gateway "$LYDIA_ROOT"
    fi

    if [[ "$SERVICES" == *"ui"* ]]; then
        printf '\n# Building Flutter web app...\n\n'
        sleep 1

        cd "$LYDIA_ROOT/lydia_client"
        flutter build web --web-renderer canvaskit --release --dart-define-from-file="dev.config.json"
        cd "$LYDIA_ROOT"
    fi
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
    flutter build web --web-renderer canvaskit --release --dart-define-from-file="demo.config.json"
    cd "$LYDIA_ROOT"

    echo "Deploying to Cloud Run..."
    gcloud run deploy --source "$LYDIA_ROOT" --update-env-vars JWT_SECRET=$(openssl rand -base64 40)
}

export SCRIPTS_DIR="$LYDIA_ROOT/scripts"

source "$SCRIPTS_DIR/lydia-http.sh"
