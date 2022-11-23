function nav {
    cd ~/
    local target=$(fd --no-ignore-vcs -t d -H | fzf)
    if [ ! -z "$target" ]; then
        cd $target 
    else
        cd -
        return 1
    fi
}