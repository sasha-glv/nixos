{ config, pkgs, lib, inputs, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
    ];
  boot.supportedFilesystems = [ "zfs" ];
  networking.hostId = "e10afd9f";

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  boot.zfs.extraPools = [ "fast" "nori" "backup" ];

  time.timeZone = "Europe/Amsterdam";

  networking.hostName = "nain";

  services.openssh.enable = true;
  system.copySystemConfiguration = true;

  # This works through our custom module imported above
  nixpkgs.config.allowUnsupportedSystem = true;

  system.stateVersion = "22.05";

  boot.loader.systemd-boot.consoleMode = "0";

  networking.firewall.allowedTCPPorts = [ 22 8080 22000 2049 ];
  networking.firewall.allowedUDPPorts = [ 3478 22000 21027 ];
  networking.firewall.interfaces.tailscale0.allowedTCPPorts = [ 5201 8443 4444 8384 ];
  # Allow tailscale through the firewall
  networking.firewall.checkReversePath = "loose";

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

    /* displayManager.gdm.enable = true; */
    /* desktopManager.gnome.enable = true; */

  };
  # Enable i3
  services.xserver.windowManager.i3.enable = true;

  # Lightdm
  services.xserver.displayManager.lightdm = {
    enable = true;
    greeters.gtk.enable = true;
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

  services.zfsBackupReplication = {
    enable = true;
    datasets = [
      {
        name = "fast/doc-store";
        remote = "backup/doc-store";
        serviceName = "zfs-backup-doc-store-durin";
        remoteHost = "durin";
        user = "sashka";
      }
      {
        name = "fast/doc-store";
        remote = "backup/doc-store";
        serviceName = "zfs-backup-doc-store-nain";
        remoteHost = "nain";
        user = "sashka";
      }
      {
        name = "fast/sync";
        remote = "backup/sync";
        serviceName = "zfs-backup-sync-nain";
        remoteHost = "nain";
        user = "sashka";
      }
      {
        name = "fast/sync";
        remote = "backup/sync";
        serviceName = "zfs-backup-sync-durin";
        remoteHost = "durin";
        user = "sashka";
      }
    ];
  };

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    inputs.helix.packages.${system}.helix
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
