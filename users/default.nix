{...}: let
    authorizedKeys = [
        "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQDkXEf4mDH+g5jMl8+9Lw5Y35mtEjvtBruiWlXIdCkEnx1g+0i5MKv9btF1zf0C5eVVgJvtqQ7hUOK//1SlcsqNIoAffxu99D3mHjz6FPbuyl7ZEsmGQMcHMob6sd4x5yY3A022xB7XjKQHEB98RBBQtp0nn5w0FiC3eXUfBveHgeEErQ9rGwj+9VmCfCEgGgKRaP93Iy/eqa1DWvAMyZvPSqtlfhvA57u4feWFbzkGdWhkiRdIlFzdZwUwSQ3Zpmhp+W5yfd2gEMxfegYP/yCdwe+At3U0aRxO0V50nGN/EEPiKRCwDQ6Qqn7zHlPeuTCLznpnrp8022QYCeAjYqLlSKwV4Fbwhkv8wdYb/rSfx3KktYXyBQ5CiI2WKpXRwt/FVZXppk8B24Np4EIjypssX9X3YD6xUxdveJVluV9+3eLGXgBLoYCmpggFnqfzBlo+t0N717ZTyCj1ouY/4b/22xwIcLVC7Sq6O3nkKYsUvrEpNa7AZKBbexpl6XzXrgc="
    ];
in
{
    users.users = {
        sashka = {
            password = "sashka";
            isNormalUser = true;
            extraGroups = [ "wheel" ];
            openssh.authorizedKeys.keys = authorizedKeys;
        };
        root = {
            openssh.authorizedKeys.keys = authorizedKeys;
        };
    };
}