# Nixos install

SSH into the box under root.

Make partitions

``` sh
# 2x SSDs for VMs
parted /dev/sda -- mklabel gpt
parted -a optimal /dev/sda -- mkpart primary 0% 100%
parted /dev/sdb -- mklabel gpt
parted -a optimal /dev/sdb -- mkpart primary 0% 100%
mkfs.ext4 -L vm1 /dev/sda1
mkfs.ext4 -L vm2 /dev/sdb1
```
