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

  users.users.root.openssh.authorizedKeys.keys = [
    "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQDkXEf4mDH+g5jMl8+9Lw5Y35mtEjvtBruiWlXIdCkEnx1g+0i5MKv9btF1zf0C5eVVgJvtqQ7hUOK//1SlcsqNIoAffxu99D3mHjz6FPbuyl7ZEsmGQMcHMob6sd4x5yY3A022xB7XjKQHEB98RBBQtp0nn5w0FiC3eXUfBveHgeEErQ9rGwj+9VmCfCEgGgKRaP93Iy/eqa1DWvAMyZvPSqtlfhvA57u4feWFbzkGdWhkiRdIlFzdZwUwSQ3Zpmhp+W5yfd2gEMxfegYP/yCdwe+At3U0aRxO0V50nGN/EEPiKRCwDQ6Qqn7zHlPeuTCLznpnrp8022QYCeAjYqLlSKwV4Fbwhkv8wdYb/rSfx3KktYXyBQ5CiI2WKpXRwt/FVZXppk8B24Np4EIjypssX9X3YD6xUxdveJVluV9+3eLGXgBLoYCmpggFnqfzBlo+t0N717ZTyCj1ouY/4b/22xwIcLVC7Sq6O3nkKYsUvrEpNa7AZKBbexpl6XzXrgc="
  ];

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

  services.k8s_haproxy = {
    enable = true;
    backends = ["eldalote 10.200.0.10" "aegnor 10.200.0.11" "galadriel 10.200.0.12"];
  };
  system.copySystemConfiguration = true;

  system.stateVersion = "22.05"; # Did you read the comment?

  systemd.services.qemu-guest-agent.enable = true;
  networking.firewall.enable = false;

}

