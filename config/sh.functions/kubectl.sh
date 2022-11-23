function kube-context {
    local target=$(kubectl config get-contexts -o name | fzf)
    if [[ -z $target ]]; then
        return 0
    fi
    if [[ $target == "nil" ]]; then
        kubectl config unset current-context
        return 0
    fi
    kubectl config use-context $target
}
