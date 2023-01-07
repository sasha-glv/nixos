{ config, pkgs, lib, inputs, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
    ];

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  boot.supportedFilesystems = [ "zfs" ];
  networking.hostId = "29ddef08";
  boot.zfs.extraPools = ["backup"];

  time.timeZone = "Europe/Amsterdam";

  networking.hostName = "durin";

  services.openssh.enable = true;
  system.copySystemConfiguration = true;

  # This works through our custom module imported above
  nixpkgs.config.allowUnsupportedSystem = true;

  system.stateVersion = "22.05";

  boot.loader.systemd-boot.consoleMode = "0";

  networking.firewall.allowedTCPPorts = [ 22 8080 ];
  networking.firewall.allowedUDPPorts = [ 3478 ];
  # Allow tailscale through the firewall
  networking.firewall.checkReversePath = "loose";
  networking.firewall.interfaces.tailscale0.allowedTCPPorts = [ 5201 8443 4444 ];

  boot.kernelPackages = config.boot.zfs.package.latestCompatibleLinuxPackages;

  nix = {
    # use unstable nix so we can access flakes
    package = pkgs.nixUnstable;
    extraOptions = ''
      experimental-features = nix-command flakes
      keep-outputs = true
      keep-derivations = true
    '';
  };

  # We expect to run the VM on hidpi machines.
  hardware.video.hidpi.enable = true;

  security.polkit.enable = true;
  # Don't require password for sudo
  security.sudo.wheelNeedsPassword = false;

  # Virtualization settings
  virtualisation.docker = {
    enable = true;
    daemon.settings = {
      "bip" = "192.168.65.1/24";
    };
  };

  # Select internationalisation properties.
  i18n.defaultLocale = "en_US.UTF-8";

  # setup windowing environment
  services.xserver = {
    enable = true;
    layout = "us";
    dpi = 220;

    displayManager.gdm.enable = true;
    desktopManager.gnome.enable = true;

  };

  services.tailscale.enable = true;

  # Manage fonts. We pull these from a secret directory since most of these
  # fonts require a purchase.
  fonts = {
    fontDir.enable = true;
    fonts = with pkgs; [
      (nerdfonts.override { fonts = [ "FiraCode" ]; })
      fira-code
    ];
  };

  # enable unifi controller
  services.unifi = {
    enable = false;
    unifiPackage = pkgs.unifi7;
  };

  services.jellyfin = {
    enable = true;
    user = "jellyfin";
    group = "jellyfin";
    openFirewall = true;
  };

  # enable sway window manager
  programs.sway = {
    enable = true;
    wrapperFeatures.gtk = true;
  };

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    /* inputs.helix.packages.${system}.helix */
    swaylock
    swayidle
    swaybg
    neovim
    curl
    parted
    htop
    fd
    ripgrep
    dig
    killall
    xclip
    yubikey-manager
    sqlite
    gcc
    kbfs
    keybase
    kubectl
    nodejs-16_x
    nodePackages.yaml-language-server
    python311
    iperf3
  ];
}
