{ config, pkgs, lib, inputs, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
    ];

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.loader.grub.device = "nodev";
  boot.loader.grub.enableCryptodisk = true;
  boot.loader.grub.efiSupport = true;
  services.fwupd.enable = true;
  boot.initrd.luks.devices.crypted = {
      # the below should be a UUID as reported by `blkid`
      device = "/dev/disk/by-uuid/ea4a9dcd-26a4-4103-9040-5cb342c65249";
      preLVM = true;
  };
  time.timeZone = "Europe/Amsterdam";

  networking.hostName = "sam";

  services.openssh.enable = true;
  system.copySystemConfiguration = true;

  # enable sound
  sound.enable = true;
  hardware.pulseaudio.enable = true;
  hardware.pulseaudio.support32Bit = true;

  # This works through our custom module imported above
  nixpkgs.config.allowUnsupportedSystem = true;

  system.stateVersion = "22.05";

  boot.loader.systemd-boot.consoleMode = "0";

  networking.firewall.allowedTCPPorts = [ 22 ];
  networking.firewall.allowedUDPPorts = [  ];
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
    desktopManager.plasma5.enable = true;
    # LightDM
    displayManager.lightdm.enable = true;
    displayManager.lightdm.greeter.enable = true;

  };

  programs.ssh.askPassword = pkgs.lib.mkForce "${pkgs.ksshaskpass.out}/bin/ksshaskpass";
  programs.kdeconnect.enable = true;

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

  networking.networkmanager.enable = true;
  networking.wireless.iwd.enable = true;
  networking.networkmanager.wifi.backend = "iwd";
  #
  environment.systemPackages = with pkgs; [
    /* inputs.helix.packages.${system}.helix */
    libsForQt5.bismuth
    libsForQt5.plasma-nm
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
    logseq
  ];
}
