# nv function - launch nvim with socket based on current directory
nv() {
    local socket_path="/tmp/$(basename "$PWD")"

    # Check if socket is already in use
    if [ -S "$socket_path" ]; then
        if ! lsof "$socket_path" >/dev/null 2>&1; then
            # Socket exists but nothing is listening, remove it
            rm -f "$socket_path"
        else
            echo "Error: Socket $socket_path is already in use"
            return 1
        fi
    fi

    nvim . --listen "$socket_path"
}