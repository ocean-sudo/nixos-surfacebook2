{ lib, ... }:
{
  # Replace with real hardware config from:
  # sudo nixos-generate-config --show-hardware-config
  fileSystems."/" = lib.mkDefault {
    device = "/dev/disk/by-uuid/REPLACE-ROOT-UUID";
    fsType = "ext4";
  };

  fileSystems."/boot" = lib.mkDefault {
    device = "/dev/disk/by-uuid/REPLACE-BOOT-UUID";
    fsType = "vfat";
  };

  swapDevices = lib.mkDefault [ ];
}
