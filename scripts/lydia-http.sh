lydia-post() {
    local ROUTE="$1"
    local DATA=$2
    local HEADERS=( "Content-Type: application/json" )

    if [ -n "$LYDIA_TOKEN" ]; then
        HEADERS+=( "Authorization: Bearer $LYDIA_TOKEN" )
    fi

    local COMMAND="curl -X POST"
    
    for header in "${HEADERS[@]}"; do
        COMMAND+=" -H '$header'"
    done

    COMMAND+=" -d '$DATA'"
    COMMAND+=" 'http://localhost:1337$ROUTE'"

    eval "$COMMAND"
}
