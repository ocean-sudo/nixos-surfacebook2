{ lib, ... }:
{
  nix.settings = {
    substituters = lib.mkForce [
      "https://mirrors.tuna.tsinghua.edu.cn/nix-channels/store"
      "https://mirrors.ustc.edu.cn/nix-channels/store"
      "https://cache.nixos.org/"
    ];
    connect-timeout = 5;
    fallback = true;
    auto-optimise-store = true;
  };
}
