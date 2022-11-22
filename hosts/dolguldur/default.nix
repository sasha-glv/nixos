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

  networking.hostName = "thror";
  environment.systemPackages = with pkgs; [
    neovim
    curl
    parted
    htop
    fd
    ripgrep
    dig
    iperf3
  ];

  services.openssh.enable = true;
  system.copySystemConfiguration = true;

  system.stateVersion = "22.05";

  networking.firewall.enable = false;

}

