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
  services.qemuGuest.enable = true;
  services.minio = {
    enable = true;
    region = "eu-west-1";
    rootCredentialsFile = "/home/root/minio-credentials";
  };
  # custom.services.seafile = {
  #   enable = true;
  #   hostname = "thror";
  # };

  services.k8s_haproxy = {
    enable = true;
    backends = ["eldalote 10.200.0.10" "aegnor 10.200.0.11" "galadriel 10.200.0.12"];
  };
  system.copySystemConfiguration = true;

  system.stateVersion = "22.05";

  systemd.services.qemu-guest-agent.enable = true;
  networking.firewall.enable = false;

}

