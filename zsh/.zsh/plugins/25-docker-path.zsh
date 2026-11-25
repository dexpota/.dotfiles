docker_bin="$HOME/.docker/bin"
if [[ -d "$docker_bin" ]]; then
    typeset -U path
    path+=("$docker_bin")
fi
unset docker_bin
