# Nixos install

## Thror

SSH into the box under root.

``` sh
export HOST=thror
```

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

## Dol-guldur
SSH into the box under root.

``` sh
export HOST=dolguldur
```

Make partitions

```sh

parted /dev/nvme0n1 -- mklabel gpt
parted /dev/nvme0n1 -- mkpart ESP fat32 1MiB 512MiB
parted /dev/nvme0n1 -- mkpart primary 512MiB 100%
parted /dev/nvme0n1 -- set 1 esp on
mkfs.ext4 -L nixos /dev/nvme0n1p2
mkfs.fat -F 32 -n boot /dev/sda3

```

First install
``` sh
nixos-generate-config --root /mnt
mount /dev/disk/by-label/nixos /mnt
mkdir -p /mnt/root
cd /mnt/root/
git clone https://github.com/sasha-glv/nixos.git && cd nixos
nix-shell
nixos-install --root /mnt --impure --flake .#${HOST}
```

Rebuid

``` sh
cd /root/nixos
nixos-rebuild switch --impure --flake .#${HOST}
```
