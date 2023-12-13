export GATEWAY_HOME="$LYDIA_ROOT/gateway"

lydia-build() {
    OPTIONS="$@"

    printf '\n# Building lydia-gateway...\n\n'
    sleep 1

    docker build -t lydia-gateway "$GATEWAY_HOME"
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
    lydia run lydia-gateway "$@"
}

lydia() {
    docker compose -f "$GATEWAY_HOME/docker-compose.yml" "$@"
}
