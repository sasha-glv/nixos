function gh-pr {
  gh pr list ${@:1}
}

function gh-pr-web-view {
  gh pr view $1 --web
}

function gh-pr-date {
  D="$1"
  if [ -z "$D" ]; then
    D="yesterday"
  fi
  DS=$(date -d $D +"%Y-%m-%d")
  gh pr list --search "created:>=$DS ${@:2}"
}

function gh-pr-stale {
  DS=$(date -d "3 months ago" +'%Y-%m-%d')
  gh pr list --search "created:<=$DS" --json "url,author,title,number"
}
function gh-pr-stale-add-label {
  stale=$(gh-pr-stale)
  echo $stale | jq '.[].number' | xargs -n1 gh pr edit --add-label 'stale'
}

function gh-pr-my-table {
  gh pr list --search="author:sasha-glv" ${@:1}
}

function gh-pr-my {
  gh-pr-my-table| fzf | awk '{print $1}' | xargs -I{} gh pr view {}
}

function gh-pr-list {
  gh pr list --search="review-requested:sasha-glv" ${@:1}
}

function git-worktree-rm {
  git worktree list | fzf --multi | rg '\s.*' -r '' |  xargs -I{} git worktree remove {}
}

function git-root {
  cd $(git rev-parse --show-toplevel)
}

function git-branch {
  git branch --sort=-committerdate | fzf --multi | rg '\s' -r '' | xargs -I{} git checkout {}
}

function git-branch-delete {
  git branch --sort=-committerdate | fzf --multi | rg '\s' -r '' | xargs -I{} git branch -D {}
}

# function git-branch {
#   local arg=$1
#   local branch=$(git branch -a --format '%(refname)' 2>/dev/null | fzf )
#   branch=$(echo $branch | sed -r 's#refs/remotes/origin/(.*)$#\1#')
#   branch=$(echo $branch | sed -r 's#refs/heads/(.*)$#\1#')
#   if [[ -z $branch ]]; then
#     return 0
#   fi
#   kitty @set-tab-title 🙈 ${branch}
#   if [[ $arg == "g" ]]; then
#     git switch $branch
#     return 0
#   fi
#   local is_bare=$(git rev-parse --is-bare-repository)
#   local top=""
#   if [[ $is_bare == "true" ]]; then
#     top=$(pwd)
#   else
#     top=$(git rev-parse --show-toplevel 2>/dev/null | sed -r 's#(.*)/+([^/]+)$#\1#g')
#   fi

#   worktree_path=$(echo $branch | sed 's#/#-#g')
#   if [[ $top != "" ]]; then
#     git worktree add $top/${worktree_path} ${branch} && cd $top/${worktree_path}
#   else
#     git worktree add ${worktree_path} ${branch}
#   fi
# }

