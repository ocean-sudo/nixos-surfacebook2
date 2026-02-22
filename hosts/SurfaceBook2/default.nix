{ ... }:
{
  imports = [
    ./hardware-configuration.nix
    ../../modules/common/base.nix
    ../../modules/common/locale-zh.nix
    ../../modules/common/mirrors-cn-minimal.nix
    ../../modules/common/nvidia-surfacebook2.nix
    ../../modules/common/niri-core.nix
  ];

  networking.hostName = "SurfaceBook2";
}
