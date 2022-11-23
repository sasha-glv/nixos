function vault-apikey-find {
    local VAULT_ENV=$(cat ~/.vault_tokens | jq -r 'to_entries|.[] | .key' | fzf)
    if [[ "${VAULT_ENV}" == "" ]]; then
        exit
    fi
    cat ~/.vault_tokens | jq --arg vault_env "${VAULT_ENV}" -r 'to_entries | .[] | select(.key==$vault_env) | .value' | pbcopy
}

function vault-key-find {

    # Recursive function that will
    # - List all the secrets in the given $path
    # - Call itself for all path values in the given $path
    function traverse {
        local p="$1"

        result=$(vault kv list -format=json $p 2>&1)

        ret=$?
        if [ ! $ret -eq 0 ];
        then
            if [[ $result =~ "permission denied" ]]; then
                return
            fi
            >&2 echo "$result"
        fi

        for secret in $(echo "$result" | jq -r '.[]'); do
            if [[ "$secret" == */ ]]; then
                traverse "$p$secret"
            else
                echo "$p$secret"
            fi
        done
    }

    # Iterate on all kv engines or start from the path provided by the user
    if [[ "$1" ]]; then
        # Make sure the path always end with '/'
        vaults=("${1%"/"}/")
    else
        vaults=$(vault secrets list -format=json | jq -r 'to_entries[] | select(.value.type =="kv") | .key')
    fi

    for vault in $vaults; do
        traverse $vault
    done
}
