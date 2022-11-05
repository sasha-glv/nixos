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

  networking.hostName = "dain";
  environment.systemPackages = with pkgs; [
    neovim # Do not forget to add an editor to edit configuration.nix! The Nano editor is also installed by default.
    curl
    parted
    htop
  ];

  services.openssh.enable = true;
  services.qemuGuest.enable = true;

  system.copySystemConfiguration = true;

  system.stateVersion = "22.05"; # Did you read the comment?

  systemd.services.qemu-guest-agent.enable = true;
  networking.firewall.enable = true;
  networking.firewall.allowedTCPPorts = [ 6443 ];
}
