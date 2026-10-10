alias zell="zellij"

# Start sesh
function start() {
    local dir="${1:-.}"
    dir=$(realpath "$dir")
    nohup ~/.local/bin/ncspot-autostart.sh > /dev/null 2>&1 &
    disown
    cd "$dir" && ZELLIJ_DEFAULT_CWD="$dir" zellij --layout ~/.config/zellij/layouts/dev.kdl
}
# Kill sesh
function stop() {
    zellij kill-session --yes 2>/dev/null || zellij kill-all-sessions --yes 2>/dev/null
}
