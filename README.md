# Nixos install

SSH into the box under root.

Make partitions

``` sh
# 2x SSDs for VMs
parted /dev/sda -- mklabel gpt
parted -a optimal /dev/sda1 -- mkpart primary 0% 100%
parted /dev/sdb -- mklabel gpt
parted -a optimal /dev/sdb1 -- mkpart primary 0% 100%
mkfs.ext4 -L vm1 /dev/sda1
mkfs.ext4 -L vm2 /dev/sdb1
mount /dev/disk/by-label/vm1 /mnt
```

``` sh
cd /etc/nixos
git clone https://github.com/sasha-glv/nixos.git
nix shell
nixos-rebuild switch --impure --flake /etc/nixos/nixos#${HOST}
```
