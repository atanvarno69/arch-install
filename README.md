# Arch Install

Helpers to install Arch linux.

## Install live environment

> [!NOTE]
> If archiso doesn't have enough space available:
> `mount -o remount,size=1G /run/archiso/cowspace`

From the install environment:

```sh
loadkeys uk
```

* Setup partitions: `cgdisk`
  * ESP, type `EF00`
  * /root, type `8304`
  * optional /boot, (if ESP at /efi not /boot) type `ea00` (See [Installation using XBOOTLDR](https://wiki.archlinux.org/title/Systemd-boot#Installation_using_XBOOTLDR) and [Alternative mount points, Using systemd](https://wiki.archlinux.org/title/EFI_system_partition#Alternative_mount_points))
  * optional /home, type `8302`
  * optional swap, type `8200`
  * optional /srv, type `8306`

You can use the provided `configuration.dist.json` with `archinstall`:

```
archinstall --config https://raw.githubusercontent.com/atanvarno69/arch-install/refs/heads/main/user_configuration.dist.json
```

Be sure to set a root password, but create no other users.

```sh
arch-chroot /mnt
```

Setup `systemd-boot` (See [systemd-boot](https://wiki.archlinux.org/title/Systemd-boot#Installing_the_UEFI_boot_manager))
```sh
mkdir /etc/pacman.d/hooks`
```

`/etc/pacman.d/hooks/95-systemd-boot.hook`:

```
[Trigger]
Type = Package
Operation = Upgrade
Target = systemd

[Action]
Description = Gracefully upgrading systemd-boot...
When = PostTransaction
Exec = /usr/bin/systemctl restart systemd-boot-update.service
```
