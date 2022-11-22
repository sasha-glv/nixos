{ config, pkgs, ... }:

{
  # Home Manager needs a bit of information about you and the
  # paths it should manage.
  home.username = "sashka";
  home.homeDirectory = "/home/sashka";

  # This value determines the Home Manager release that your
  # configuration is compatible with. This helps avoid breakage
  # when a new Home Manager release introduces backwards
  # incompatible changes.
  #
  # You can update Home Manager without changing this value. See
  # the Home Manager release notes for a list of state version
  # changes in each release.
  home.stateVersion = "22.05";

  # Add packages - zsh, firefox, nvim, vscode, emacs, kitty
  programs = {
    zsh.enable = true;
    firefox.enable = true;
    neovim.enable = true;
    kitty.enable = true;
    emacs.enable = true;
    vscode.enable = true;
    home-manager.enable = true;
  };
}
