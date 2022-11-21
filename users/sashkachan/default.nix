{lib, pkgs, ...}:
{
    users.users.sashkachan = {
        password = "sashkachan";
    
        isNormalUser = true;
        extraGroups = [ "wheel" ];
    };
}