{ config, pkgs, lib, system, gui, ... }:
{
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

  # Add zellij config
  home.file."${config.xdg.configHome}/zellij/zellij".source = ../../config/zellij/zellij;

  # Add starship/starship.toml config
  home.file."${config.xdg.configHome}/starship/starship.toml".source = ../../config/starship/starship.toml;

  # Add alacritty config
  home.file."${config.xdg.configHome}/alacritty/alacritty.yml".source = ../../config/alacritty/alacritty.yml;

  # Add nixpkg config
  home.file."${config.home.homeDirectory}/.config/nixpkgs/config.nix".source = ../../config/nixpkgs/config.nix;

  # Add i3 config
  home.file."${config.xdg.configHome}/i3/config".source = ../../config/i3/config;

  # Add i3status
  home.file."${config.xdg.configHome}/i3/i3status".source = ../../config/i3/i3status;

  # Enable syncthing
  services.syncthing = {
    enable = true;
  };

  services.keybase.enable = true;
  services.kbfs.enable = true;

  programs = {
    git = {
      enable = true;
      userName = "Sasha Guljajev";
      userEmail = "sasha@zxcvmk.com";
      signing = {
        signByDefault = true;
        key = "FAE411852283959B";
      };
      extraConfig = {
        github.user = "sasha-glv";
      };
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
    gpg = {
      enable = true;
    };
    fzf = {
      enable = true;
      enableBashIntegration = true;
    };
    bash = {
      enable = true;
      enableCompletion = true;
      initExtra = ''
        source ${config.home.homeDirectory}/sh.functions/vault.sh
        source ${config.home.homeDirectory}/sh.functions/kubectl.sh
        source ${config.home.homeDirectory}/sh.functions/nav.sh
        source ${config.home.homeDirectory}/sh.functions/git.sh
        source ${config.home.homeDirectory}/sh.functions/boilerplate.sh
        alias magit='emacs -nw --eval "(magit-status)"'
        export EDITOR=nvim
        export TERM=xterm-256color
      '';
    };
    firefox = {
      enable = true;
    };
    neovim = {
      enable = true;
      package = pkgs.neovim-nightly;
    };
    kitty = {
      enable = gui;
      theme = "Modus Vivendi";
      extraConfig = builtins.readFile ../../config/kitty/kitty.conf;
    };
    emacs = {
      enable = true;
      package = pkgs.emacsUnstable;
      extraPackages = (epkgs: [ epkgs.vterm epkgs.emacsql-sqlite3 ] );
    };

    vscode.enable = true;
    home-manager.enable = true;
    zellij.enable = true;
    btop.enable = true;
    go = {
      enable = true;
    };

    gh = {
      enable = true;
    };

    starship = {
      enable = true;
    };

    # Enable alacritty
    alacritty = {
      enable = true;
    };

    i3status = {
      enable = gui;

      general = {
      };

      modules = {
        ipv6.enable = false;
        "wireless _first_".enable = false;
        "battery all".enable = false;
      };
    };
  };
}
