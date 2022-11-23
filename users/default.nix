{nixpkgs, ...}: let
    authorizedKeys = [
        "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQDkXEf4mDH+g5jMl8+9Lw5Y35mtEjvtBruiWlXIdCkEnx1g+0i5MKv9btF1zf0C5eVVgJvtqQ7hUOK//1SlcsqNIoAffxu99D3mHjz6FPbuyl7ZEsmGQMcHMob6sd4x5yY3A022xB7XjKQHEB98RBBQtp0nn5w0FiC3eXUfBveHgeEErQ9rGwj+9VmCfCEgGgKRaP93Iy/eqa1DWvAMyZvPSqtlfhvA57u4feWFbzkGdWhkiRdIlFzdZwUwSQ3Zpmhp+W5yfd2gEMxfegYP/yCdwe+At3U0aRxO0V50nGN/EEPiKRCwDQ6Qqn7zHlPeuTCLznpnrp8022QYCeAjYqLlSKwV4Fbwhkv8wdYb/rSfx3KktYXyBQ5CiI2WKpXRwt/FVZXppk8B24Np4EIjypssX9X3YD6xUxdveJVluV9+3eLGXgBLoYCmpggFnqfzBlo+t0N717ZTyCj1ouY/4b/22xwIcLVC7Sq6O3nkKYsUvrEpNa7AZKBbexpl6XzXrgc="
        "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQC/3/uUREGRBXkZLWbDzVtuJTIItVjA1iwtOK2/d/aAY2ohYTmpLi2lWmrJCuDj2RY6ZXzgJ1JUdoKqNDinXve1FGTcUcb2ZmWPcaQNxSGD/dLLPLc6k136e9HuAQ+F8lzsYG5G6aY057bAIiAju1Bq7OQYPJ5SAZwEFxdD4XRTdqPZTrE5PtiV5yrLGz67Q/aeDxSUsLFIx3bbJsmffcxuK3LeOsIUJzjo/txB/ZmwADkhCVzq1zd+0OAUs8PcxjVib22kz80rgBZLdrSGVRHuMRbxwIU/xlB25EzNxBFRS7VZl5qHPkL75BKm4XeustFfCeVhuTtWtYO+XW8xk5Ufn79QwlCrB/oBqgtDJy8hMxQk1JOvU8nsrvZZmNnSYvdssdJTEh7t+sBOlOlg6xpikJVpAzO/jHV4LT6C0XJdnxA0ySmKTDZiBZOiqifMGpgq/U2PB0oru8zrFLgE3FAaEMuA9EmfzvGLqwgzoAJ7+B9YiEg0t+EAKF7QU6sGsWE= sashka@office-imac.local"
        "ecdsa-sha2-nistp256 AAAAE2VjZHNhLXNoYTItbmlzdHAyNTYAAAAIbmlzdHAyNTYAAABBBGxyfPgpySrQIMxnC7LiKq5yo1S4Rq8jwPK2BDtoCwBQI2zGLzVKnNZlblLMt2gqM+5hK2xatYfSGxhpWpFLfPo="
        "ecdsa-sha2-nistp256 AAAAE2VjZHNhLXNoYTItbmlzdHAyNTYAAAAIbmlzdHAyNTYAAABBBHwKwfDzRwXOCT0e4QcXBP3PXPf+bvfRp9DrMq4cp0L9UA6eB/bkPKXYIWMov9YgzNbGt2VsXRm29lfPkX0RXLE="
    ];
in
{
    users.users = {
        sashka = {
            # Set default shell to zsh
            shell = (import <nixpkgs> {}).pkgs.zsh;
            password = "sashka";
            isNormalUser = true;
            extraGroups = [ "wheel" "docker" ];
            openssh.authorizedKeys.keys = authorizedKeys;
        };
        root = {
            openssh.authorizedKeys.keys = authorizedKeys;
        };
    };
}