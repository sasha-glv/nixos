{ config, pkgs, lib, inputs, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
    ];
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  # Setup qemu so we can run x86_64 binaries
  boot.binfmt.emulatedSystems = ["x86_64-linux"];

  time.timeZone = "Europe/Amsterdam";

  networking.hostName = "dol-guldur";

  services.openssh.enable = true;
  system.copySystemConfiguration = true;

  # This works through our custom module imported above
  virtualisation.vmware-aarch64.guest.enable = true;
  nixpkgs.config.allowUnsupportedSystem = true;

  system.stateVersion = "22.05";

  boot.loader.systemd-boot.consoleMode = "0";

  disabledModules = [ "virtualisation/vmware-guest.nix" ];

  # Allow SSH access through the firewall
  networking.firewall.allowedTCPPorts = [ 22 ];

  # Allow tailscale through the firewall
  networking.firewall.checkReversePath = "loose";

  # Disable ipv6
  networking.enableIPv6 = false;

  boot.kernelPackages = pkgs.linuxPackages_latest;

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
  # Enabl i3
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

  # Add extra certificates from local file certs.pem
  security.pki.certificates = [ ''
    ${builtins.readFile ./files/certs.pem}
    ''
  ];

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
    vault
    sqlite
    gcc
    kbfs
    keybase
    kubectl
    terraform
    google-cloud-sdk
    awscli
    nodejs-16_x
    nodePackages.yaml-language-server
    python311
    # For hypervisors that support auto-resizing, this script forces it.
    # I've noticed not everyone listens to the udev events so this is a hack.
    (writeShellScriptBin "xrandr-auto" ''
      xrandr --output Virtual-1 --auto
    '')

    # This is needed for the vmware user tools clipboard to work.
    # You can test if you don't need this by deleting this and seeing
    # if the clipboard sill works.
    gtkmm3
    rust-analyzer
  ];


}
