{ config, pkgs, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
    ];

  # Use the GRUB 2 boot loader.
  boot.loader.grub.enable = true;
  boot.loader.grub.version = 2;
  boot.loader.grub.device = "/dev/sda"; # or "nodev" for efi only

  time.timeZone = "Europe/Amsterdam";

  users.users.sashka = {
    isNormalUser = true;
    extraGroups = [ "wheel" ]; # Enable ‘sudo’ for the user.
  };

  networking.hostName = "thror";
  environment.systemPackages = with pkgs; [
    neovim # Do not forget to add an editor to edit configuration.nix! The Nano editor is also installed by default.
    curl
    parted
    htop
    fd
    ripgrep
    dig
  ];

  services.openssh.enable = true;
  services.qemuGuest.enable = true;
  services.nextcloud = {                
    enable = true;
    package = pkgs.nextcloud25;
    hostName = "nextcloud.home.localdomain";
    config.adminpassFile = "${pkgs.writeText "adminpass" "test123"}";
    config.extraTrustedDomains = ["nextcloud.svc.home.localdomain" "nextcloud.ryebee.me"];
    config.overwriteProtocol = "https";
    home = "/mnt/nextcloud";
  };
  services.k8s_haproxy = {
    enable = true;
    backends = ["eldalote 10.200.0.10" "aegnor 10.200.0.11" "galadriel 10.200.0.12"];
  };
  system.copySystemConfiguration = true;

  system.stateVersion = "22.05"; # Did you read the comment?

  systemd.services.qemu-guest-agent.enable = true;
  networking.firewall.enable = false;

}

