# Nixos install

SSH into the box under root.

``` sh
export HOST=thror
```

`

Make partitions

``` sh
# 2x SSDs for VMs
parted /dev/sda -- mklabel msdos
parted -a optimal /dev/sda -- mkpart primary 0% 100%
parted /dev/sdb -- mklabel gpt
parted -a optimal /dev/sdb -- mkpart primary 0% 100%
mkfs.ext4 -L vm1 /dev/sda1
mkfs.ext4 -L vm2 /dev/sdb1
mount /dev/disk/by-label/vm1 /mnt
```

First install
``` sh
mkdir -p /mnt/home/root
cd /mnt/home/root/
git clone https://github.com/sasha-glv/nixos.git && cd nixos
nix-shell
nixos-install --root /mnt --impure --flake .#${HOST}
```

Rebuid

``` sh
cd /home/root/nixos
nixos-rebuild switch --impure --flake .#${HOST}
```

`
