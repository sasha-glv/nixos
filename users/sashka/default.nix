{ config, pkgs, lib, ... }:

{
  # Home Manager needs a bit of information about you and the
  # paths it should manage.
  home.username = "sashka";
  home.homeDirectory = "/home/sashka";

  home.stateVersion = "22.05";

  # Add fd config
  home.file."${config.xdg.configHome}/fd/ignore".source = ../../config/fd/ignore;

  # Add helix config
  home.file."${config.xdg.configHome}/helix/config.toml".source = ../../config/helix/config.toml;
  home.file."${config.xdg.configHome}/helix/languages.toml".source = ../../config/helix/languages.toml;

  # add neovim lua config
  home.file."${config.xdg.configHome}/nvim/init.lua".source = ../../config/nvim/init.lua;

  # Add sh functions
  home.file."${config.home.homeDirectory}/sh.functions".source = ../../config/sh.functions;

  # Add doom.d config
  home.file."${config.home.homeDirectory}/.doom.d/config.el".source = ../../config/doom.d/config.el;
  home.file."${config.home.homeDirectory}/.doom.d/packages.el".source = ../../config/doom.d/packages.el;
  home.file."${config.home.homeDirectory}/.doom.d/init.el".source = ../../config/doom.d/init.el;

  # # Source scripts from zsh

  # home.sessionVariables.HOME_MANAGER_SHELL_INIT = ''
  #   source ${config.home.homeDirectory}/sh.functions/vault.sh
  #   source ${config.home.homeDirectory}/sh.functions/kubectl.sh
  #   source ${config.home.homeDirectory}/sh.functions/nav.sh
  #   source ${config.home.homeDirectory}/sh.functions/git.sh
  # '';



  # Configure git
  programs.git = {
    enable = true;
    userName = "Sasha Guljajev";
    userEmail = "sasha@zxcvmk.com";
    aliases = {
      co = "checkout";
      ci = "commit";
      st = "status";
      br = "branch";
      hist = "log --pretty=format:'%h %ad | %s%d [%an]' --graph --date=short";
      type = "cat-file -t";
      dump = "cat-file -p";
      dlast = "diff HEAD~1";
      dmaster = "diff HEAD master";
    };

  };

  # Add packages - zsh, firefox, nvim, vscode, emacs, kitty
  programs = {
    gpg = {
      enable = true;
    };
    zsh = {
      enable = true;
      enableAutosuggestions = true;
      enableSyntaxHighlighting = true;
      enableCompletion = true;
      initExtra = ''
        select-word-style bash
        source ${config.home.homeDirectory}/sh.functions/vault.sh
        source ${config.home.homeDirectory}/sh.functions/kubectl.sh
        source ${config.home.homeDirectory}/sh.functions/nav.sh
        source ${config.home.homeDirectory}/sh.functions/git.sh
      '';
      history = {
        share = true;
        size = 10000000;
      };
    };
    fzf = {
      enable = true;
      enableZshIntegration = true;
    };
    firefox.enable = true;
    neovim = {
      enable = true;
      package = pkgs.neovim-nightly;
    };
    kitty = {
      theme = "Modus Vivendi";
      enable = true;
      extraConfig = builtins.readFile ../../config/kitty/kitty.conf;
    };
    emacs = {
      enable = true;
      package = pkgs.emacsNativeComp;
      extraPackages = (epkgs: [ epkgs.vterm epkgs.emacsql-sqlite ] );
    };
    vscode.enable = true;
    home-manager.enable = true;
    helix = {
      enable = true;
      package = pkgs.helix;
    };
  };
}
