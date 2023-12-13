lydia-post() {
    local ROUTE="$1"
    local DATA=$2

    curl -X POST -H "Content-Type: application/json" -d "$DATA" "http://localhost:1337$ROUTE"
}
