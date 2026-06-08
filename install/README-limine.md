# Limine Boot Flow

This documents the current boot flow for this machine.

```text
Power on
  |
  v
UEFI firmware
  |
  | boots NVRAM entry: "Limine"
  | file: /boot/EFI/limine/limine_x64.efi
  | fallback: /boot/EFI/BOOT/BOOTX64.EFI
  v
Limine bootloader
  |
  | reads config:
  | /boot/limine.conf
  |
  | menu entries include:
  | - Arch Linux
  | - Snapshots
  | - EFI fallback
  v
Select "Arch Linux" -> entry //linux
  |
  | loads kernel:
  | /boot/1564b915cf6845f088a1aa567cc3b133/linux/vmlinuz-linux
  |
  | loads initramfs:
  | /boot/1564b915cf6845f088a1aa567cc3b133/linux/initramfs-linux
  |
  | passes cmdline:
  | quiet splash
  | cryptdevice=PARTUUID=e251a2de-916c-411f-ae2a-3f88328e28fb:root
  | root=/dev/mapper/root
  | zswap.enabled=0
  | rootflags=subvol=@
  | rw
  | rootfstype=btrfs
  v
Linux kernel starts
  |
  | unpacks initramfs into RAM
  v
Initramfs early userspace
  |
  | built earlier by: mkinitcpio
  | hooks include:
  | base udev keyboard autodetect microcode modconf kms
  | keymap consolefont block encrypt filesystems fsck
  | btrfs-overlayfs
  |
  | steps:
  | - detect hardware/devices
  | - load storage support
  | - enable keyboard/keymap
  | - unlock encrypted partition via cryptdevice=...
  | - create /dev/mapper/root
  | - mount btrfs filesystem
  | - mount subvolume @ as real root
  v
switch_root
  |
  | leaves temporary RAM filesystem
  | enters real root filesystem
  v
Real system root
  |
  | mounted from:
  | /dev/mapper/root
  |
  | filesystem:
  | btrfs
  |
  | subvolume:
  | @
  v
systemd (PID 1)
  |
  | starts mounts, services, networking,
  | display manager, user session, desktop
  v
Fully booted system
```

Snapshot boot is the same flow except this part changes:

```text
rootflags=subvol=/@/.snapshots/<id>/snapshot
```

So instead of booting subvolume `@`, it boots that Snapper snapshot.

The maintenance flow before reboot is:

```text
pacman update
  ->
mkinitcpio rebuilds initramfs
  ->
limine-update / limine-entry-tool refresh /boot/limine.conf
  ->
next reboot uses the new boot artifacts
```
