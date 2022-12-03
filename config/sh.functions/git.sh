# Iterate over projects in projects dir, and get all PRs
# for each project.
function gh-run-in-projects() {
  # Array of projects
  projects=( $(ls -d ~/projects/*) )
  outputs=()

  for project in "${projects[@]}"; do
    project_git=$(cd $project && git remote get-url origin 2>/dev/null)
    if [ ! -z "$project_git" ]; then
      output=$($@ $project_git)
      outputs+=($output)
    fi
  done
  echo "${outputs[@]}"
}

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
  gh-run-in-projects gh pr list --search="author:sasha-glv" ${@:1} -R

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
