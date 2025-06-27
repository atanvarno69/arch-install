# Arch Install

Helpers to install and configure Arch linux.

> [!CAUTION]
> To use these helpers, you must follow the Arch Linux installation procedure given in this document. These helpers
> assume this procedure has been followed and can break things if it hasn't.

## Arch Linux installation procedure

> [!NOTE]
> The instructions assume a UK locale and British English. You can change that if you want.

Follow these steps of the [Arch Linux Installation Guide](https://wiki.archlinux.org/title/Installation_guide):

* [1.1 Acquire an installation image](https://wiki.archlinux.org/title/Installation_guide#Acquire_an_installation_image)
* [1.2 Verify signature](https://wiki.archlinux.org/title/Installation_guide#Verify_signature)
* [1.3 Prepare an installation medium](https://wiki.archlinux.org/title/Installation_guide#Prepare_an_installation_medium)
* [1.4 Boot the live environment](https://wiki.archlinux.org/title/Installation_guide#Boot_the_live_environment)

### Live environment

> [!TIP]
> If at some point archiso doesn't have enough space available:
> `mount -o remount,size=1G /run/archiso/cowspace`

#### Live environment console keyboard layout and font

(See [1.5 Set the console keyboard layout and font](https://wiki.archlinux.org/title/Installation_guide#Set_the_console_keyboard_layout_and_font).)

```sh
loadkeys uk
```

#### Verify the boot mode

(See [1.6 Verify the boot mode](https://wiki.archlinux.org/title/Installation_guide#Verify_the_boot_mode).)

Check you are in UEFI boot mode. This command should return 64 (or 32):

```sh
cat /sys/firmware/efi/fw_platform_size
```

> [!WARNING]
> If you are not in UEFI boot mode, do **not** continue. You **must** use UEFI to boot. See your motherboard manual for
> how to boot via UEFI.

#### Connect to the internet

(See [1.7 Connect to the internet](https://wiki.archlinux.org/title/Installation_guide#Connect_to_the_internet).)

Wired connection should automatically be connected.

For a wireless connection, see [instructions for `iwdctl`](https://wiki.archlinux.org/title/Iwd#iwctl).

Check you are connected:

```sh
ping -c 3 archlinux.org
```

> [!WARNING]
> If you are not connected to the internet, do **not** continue. You **must** be connected to the internet.

#### Partition the disks

(See [1.9](https://wiki.archlinux.org/title/Installation_guide#Partition_the_disks).)

Broadly, you have two options for your partition layout: simple and advanced. (The mount points given here refer to the
final system, not the installation environment.)

The **simple** layout has a root partition mounted at `/` and an ESP mounted at `/boot`.

The **advanced** layout has a root partition mounted at `/`, an ESP mounted at `/efi`, and an XBOOTLDR partition mounted
at `/boot`.

Both layouts can have additional partitions, e.g. `/home`, `/data`, `/srv`, etc., which you can configure during
installation or later. This guide only considers a single disk with root, ESP and (optionally XBOOTLDR) partions.
Additional disks and/or partitions are not relevant for making the system bootable. Feel free to add in your additional
disks/partitions in the relevant steps of this, guide. If you're not sure when the relevant steps are, stick to the
simple layout and worry about configuring additional partitions later, once you have a working system.

Likewise, if you want to use filesystems other than the default FAT32 and ext4, adapt this guide as necessary. See the
Appendix regarding EFI filesystem drivers.

> [!IMPORTANT]
> Do **not** setup a swap partition. These helpers will provide swap after installation.

Discover and note your disk's name. This will be in the form "/dev/*something*":

```sh
fdisk -l
```

Run `cgdisk` to create the partitions:

```sh
cgdisk [disk name]
```

If the disk does not have a partition table yet, ignore the "Warning! Non-GPT or damaged disk detected!" message from `cgdisk`, just hit `Enter` to proceed.

If the disk already has partitions present, delete all of them: Use the arrow keys to select each partition and hit `D`.
Once only "free space" is listed, continue.

Follow **one** of the subsections [Simple layout] *or* [Advanced layout]. Optionally you can read
subsections [Additional disk] and [Additional partitions].

##### Simple layout

Create the ESP:

* Type `N` to enter the menu
* Hit `Enter` to accept the default first sector
* Type `1G` and hit `Enter` to specify the size
* Type `ef00` and hit `Enter` to specify the type
* Type `ESP` and hit `Enter` to specify the label

Create the root partition:

* Use the arrow keys to select the "free space" below the ESP
* Type `N` to enter the menu
* Hit `Enter` to accept the default first sector
* Hit `Enter` to accept the default last sector
* Type `8304` and hit `Enter` to specify the type
* Type `ROOT_PART` and hit `Enter` to specify the label

Type `W` to write the changes, type `yes` and hit `Enter`. Type `Q` to exit `cgdisk`.

##### Advanced layout

Create the ESP:

* Type `N` to enter the menu
* Hit `Enter` to accept the default first sector
* Type `512M` and hit `Enter` to specify the size
* Type `ef00` and hit `Enter` to specify the type
* Type `ESP` and hit `Enter` to specify the label

Create the XBOOTLDR partition:

* Use the arrow keys to select the "free space" below the ESP
* Type `N` to enter the menu
* Hit `Enter` to accept the default first sector
* Type `1G` and hit `Enter` to specify the size
* Type `ea00` and hit `Enter` to specify the type
* Type `BOOT_PART` and hit `Enter` to specify the label

Create the root partition:

* Use the arrow keys to select the "free space" below the XBOOTLDR
* Type `N` to enter the menu
* Hit `Enter` to accept the default first sector
* Hit `Enter` to accept the default last sector
* Type `8304` and hit `Enter` to specify the type
* Type `ROOT_PART` and hit `Enter` to specify the label

Type `W` to write the changes, type `yes` and hit `Enter`. Type `Q` to exit `cgdisk`.

##### Additional disks

Make sure you're using GPT not MBR as your partitioning scheme. You can use `cgdisk` or `gdisk` to make sure when
partitioning. `fdisk`, `cfdisk` or `parted` can each create GPT partions with the correct inputs.

##### Additional partitions

This table provides a useful reference for setting up additional partitions in `cgdisk`.

| Partition  | `cgdisk` type ID | Recommended size | Notes   |
| :--------- | :--------------- | :--------------- | :------ |
| ESP        | `ef00`           | 512 MiB / 1 GiB  | 1       |
| `/`        | `8304`           | 15–20 GiB        | 2, 6    |
| `/boot`    | `ea00`           | 512 MiB          | 3, 4, 6 |
| `/home`    | `8302`           | *                | 5, 6    |
| `/srv`     | `8306`           | –                | 6       |
| `/usr`     | `8314`           | –                | 6       |
| `/var`     | `8310`           | 8–12 GiB         | 6       |
| `/var/tmp` | `8311`           | –                | 6       |
| other      | `8300`           | –                | 7       |

**Notes:**

1. With a seperate `/boot` (i.e. when mounted as `/efi`), 512 MiB is more than enough for the bootloader and one EFI
   driver. Some early and/or buggy UEFI implementations need a ≥ 512 MiB partition to function, hence the recommended
   size. Without a seperate `/boot` (i.e. when mounted as `/boot`) the ESP also contains kernel image(s) and microcode.
   512 MiB should be enough for one kernel, but 1 GiB provides plenty of headroom for additional kernels, other UEFI
   applications, etc. You will never need more than 4 GiB. The Arch Linux wiki recommends 1 GiB for all cases.
2. The appropriate size depends on your use case. 15–20 GiB should be sufficient and provide some margin for most cases.
   You will need less with a seperate `/var` partition. You may need more if you plan on installing a *lot* of software
   or do not have seperate partitions for storing user data.
3. This assumes your ESP is a seperate partition at `/efi`. For an ESP mounted at `/boot`, use the ESP row of the table.
4. The Arch Linux wiki recommends 1 GiB, even with a seperate `/efi`. In testing, a single `linux-zen` kernel needed
   150 MiB. 256 MiB per kernel provides ample margin. 512 MiB provides plenty of space to experiment with a couple of
   kernels and cover the majority of use cases.
5. No recommended size is provided as this is entirely dependant on your use case. `/home` should store all your users'
   data (though they may have access to other storage options too). The rule of thumb is to allocate a `/home` partition
   as much space as you can give it.
6. To be automounted, via [DPS](https://uapi-group.org/specifications/specs/discoverable_partitions_specification/),
   this partition must be on the same physical disk as the ESP.
7. Can not be automounted via [DPS](https://uapi-group.org/specifications/specs/discoverable_partitions_specification/).

#### Format the partitions

(See [1.10 Format the partitions](https://wiki.archlinux.org/title/Installation_guide#Format_the_partitions).)

Discover the identifiers of each of your partitions.

Discover and note each of your partitions' name. This will be in the form "[disk name]*something*":

```sh
fdisk -l
```

Your ESP partition is the one with the listed type of "EFI System". Create the FAT32 filesystem in it:

```sh
mkfs.fat -F 32 -n ESP_FS [name]
```

Your root partition is the one with the listed type of "Linux root (x86-64)". Create the ext4 filesystem in it:

```sh
mkfs.ext4 -L ROOT_FS [name]
```

Only if you used the advanced layout: Your XBOOTLDR partition is the one with the listed type of "Linux extended boot".
Create the ext4 filesystem in it:

```sh
mkfs.ext4 -L BOOT_FS [name]
```

#### Mount the file systems

(See [1.11 Mount the file systems](https://wiki.archlinux.org/title/Installation_guide#Mount_the_file_systems).)

Mount your root partition to `/mnt`:

```sh
mount [name] /mnt
```

Follow **one** of the subsections [Simple layout] *or* [Advanced layout], corresponding to the choice you made when
partitioning.

If you created additional filesystems on the disk, you can set appropriate mount points here or leave them unmounted.
Only mount filesystems on the same disk as the ESP (those from other disks can be mounted after installation).

##### Simple layout

Mount your ESP to `/mnt/boot`:

```sh
mount --mkdir [name] /mnt/boot
```

##### Advanced layout

Mount your ESP to `/mnt/efi`:

```sh
mount --mkdir [name] /mnt/efi
```

Mount your XBOOTLDR partition to `/mnt/boot`:

```sh
mount --mkdir [name] /mnt/boot
```

#### Installation

You are ready to proceed to installation and can run `archinstall` which is an interactive utility to automate most of
the rest of the live environment process. In `archinstall` you use the arrow keys to navigate the menus, `Space` to
(de)select items, `Enter` to progress, and `Esc` to return to the previous screen.

```sh
archinstall --config https://raw.githubusercontent.com/atanvarno69/arch-install/refs/heads/main/config.json
```
You **must** configure these settings before continuing:

* `Hostname`
* `Root password`

No other settings *need* to be configured. If you are content with the defaults provided by these tools, proceed to
install the system (skip to the end of this section). Otherwise, read these notes on the various sections:

* `Archinstall language`: Free to customize.
* `Locales`: Free to customize.
* `Mirrors`: Free to customize. Note, you do not need to. Installation will proceed fine without and these tools will
  later automate mirror management.
* `Disk configuration`: Do **not** customize. The default is configured to install using the mounts you set up earlier
  and these tools rely on disk configuration to be as expected.
* `Swap`: Do **not** customize. Adding a swap here will cause unexpected results when these tools create a swap later.
* `Unified kernel images`: Do **not** customize. This guide does not provide instructions to get a working bootloader
  with a unified kernel image. Additionally, these tools are designed to support regular kernel booting only (e.g.
  providing firmware).
* `Hostname`: You *should* customize.
* `Root password`: You **must** customize.
* `User account`: Do **not** customize. These tool provide significant user account customizations which are applied
  after archinstall creates users.
* `Profile`: You should *not* customize. The default is configured to provide a minimal install as a known base for
  these tools to work. Desktop environment installation is probably not possible without creating user accounts, which
  will break things. Non-desktop profiles install server software, some of which is redundant as it is provided and
  configured by these tools, and the rest is best installed later.
* `Audio`: You should *not* customize. The default configuration is a dependency for these tools to optionally install a
  desktop environment later. If you do not intend to have a desktop system, you can customize this.
* `Kernels`: Free to customize. The default, `linux-zen`, is probably the kernel you want, but it is not required. You
  can add more kernels if you want.
* `Network configuration`: You should *not* customize. The default configuration is a dependency for these tools to
  optionally install a desktop environment later. If you do not intend to have a desktop system, you can customize this.
  If you do, you will be responsible for getting your system connected to the internet.
* `Additional packages`: Free to customize, but see the appendix for an explaination of the default additional packages
  if you want to remove any. Adding additional packages here is not harmful, but it is probably better to install them
  on your working system later.
* `Optional respositories`: Free to customize.
* `Timezone`: Free to customize.
* `Automatic time sync (NTP)`: Free to customize.

Navigate to `Install` and hit `Enter`, confirming as needed. Once installation is complete, you will be asked if you
want to chroot into the system. Choose `Yes`.

#### Bootloader

(See [3.8 Boot loader](https://wiki.archlinux.org/title/Installation_guide#Boot_loader).)

Download and run the helper script to setup the bootloader and firmware. The script also performs other system tweaks
and downloads a copy of the tools for later use on the bootable system.

```sh
curl -s https://raw.githubusercontent.com/atanvarno69/arch-install/refs/heads/main/init.sh | sh
```

#### Reboot

(See [4 Reboot](https://wiki.archlinux.org/title/Installation_guide#Reboot).)

Exit the chroot and return to the live environment:

```sh
exit
```

Reboot the system:

```sh
reboot
```

### Working system

## Appendix

### Default packages

The default packages, provided by the `config.json` file in the `packages` key, correspond to the `archinstall` setting,
`Additional packages`. This is an explaination for each of their inclusions:

| Package         | Required | Notes                                                                                   |
| :-------------- | :------- | :-------------------------------------------------------------------------------------- |
| `amd-ucode`     | No       | The default target system uses an AMD processor. Replace with `intel-ucode` if you use Intel instead. |
| `base-devel`    | No       | This is required to use the AUR and thus some of the extra modules from these tools.    |
| `e2fsprogs`     | Yes / No | This provides ext4 utilities. This is required for a seperate `/efi` and `/boot`. See below EFI filesystem drivers explaination. |
| `git`           | Yes      | It is not required during the initial installation process but must be present on your bootable system to get and use these tools. |
| `jq`            | Yes      | It is not required during the initial installation process but must be present on your bootable system to use these tools. |
| `less`          | No       | This is the only essential [Core utility](https://wiki.archlinux.org/title/Core_utilities#Essentials) not installed by default Arch Linux. |
| `man-db`        | No       | Recommended by the [Installation guide](https://wiki.archlinux.org/title/Installation_guide#Install_essential_packages). Required to view `man` pages. |
| `man-pages`     | No       | As `man-db`.                                                                            |
| `mesa`          | No       | The default target uses a modern AMD graphics card.                                     |
| `sof-firmware`  | No       | Required firmware for most audio devices.                                               |
| `terminus-font` | No       | Used to make the linux console look better. Won't break anything if not present.        |
| `vulkan-radeon` | No       | As `mesa`.                                                                              |

### EFI filesystem drivers

In order to use a XBOOTLDR partition that contains a filesystem other than FAT32, the bootloader needs access to an
appropriate driver on the ESP. The script run to install the bootloader checks whether various filesystem userspace
utility packages are installed to decide what firmware to make available to the bootloader. Without an appropriate
userspace utility package, the bootloader will not be given the driver to mount the XBOOTLDR and, hence, the system will be
unable to boot.

This is only relevant for installs using a XBOOTLDR partition. If your ESP is mounted at `/boot` (or your XBOOTLDR is
formatted FAT32) you do not need to install a filesystem user utility package; although installing one for each
filesystem type you use is recoomended (which can be done after initial installation and setup).

| Filesystem | Userspace utility |
| :--------- | :---------------- |
| Btrfs      | `btrfs-progs`     |
| FAT32      | `dosfstools`      |
| exFAT      | `exfatprogs`      |
| F2FS       | `f2fs-tools`      |
| ext4       | `e2fsprogs`       |
| JFS        | `jfsutils`        |
| NILFS2     | `nilfs-utils`     |
| NTFS       | `ntfs-3g`         |
| UDF        | `udftools`        |
| XFS        | `xfsprogs`        |

These tools do not support using a XBOOTLDR partition with other filesystem types or remote mounts (like NFS or Samba).

