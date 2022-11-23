function set_title_precmd() {
    echo -ne "\033]0; $(basename "$PWD") \007"
}

function set_title_preexec() {
  printf "\e]2;%s\a" "$1"
}

function dotfiles {
   /usr/bin/git --git-dir=$HOME/dotfiles-git/ --work-tree=$HOME $@
}

vterm_printf(){
  printf "\e]%s\e\\" "$1"
}
vterm_prompt_end() {
    vterm_printf "51;A$(whoami)@$(hostname):$(pwd)";
}
