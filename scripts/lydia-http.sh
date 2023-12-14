lydia-post() {
    local ROUTE="$1"
    local DATA=$2
    local HEADERS=( "Content-Type: application/json" )

    if [ -n "$LYDIA_TOKEN" ]; then
        HEADERS+=( "Authorization: Bearer $LYDIA_TOKEN" )
    fi

    local COMMAND="curl -sX POST"
    
    for header in "${HEADERS[@]}"; do
        COMMAND+=" -H '$header'"
    done

    COMMAND+=" -d '$DATA'"
    COMMAND+=" 'http://localhost:1337$ROUTE'"

    local RESPONSE="$(eval "$COMMAND")"
    local EMPTY_OBJECT="{}"

    echo "${RESPONSE:-$EMPTY_OBJECT}" | python3 -m json.tool
}
