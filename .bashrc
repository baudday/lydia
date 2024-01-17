lydia-build() {
    printf '\n# Building lydia-gateway...\n\n'
    sleep 1

    docker build -t lydia-gateway "$LYDIA_ROOT"
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

export SCRIPTS_DIR="$LYDIA_ROOT/scripts"

source "$SCRIPTS_DIR/lydia-http.sh"
