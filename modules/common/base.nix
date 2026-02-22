{ pkgs, ... }:
{
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.supportedFilesystems = [ "ntfs" ];

  time.timeZone = "Asia/Shanghai";

  networking.networkmanager.enable = true;

  nix.settings.experimental-features = [ "nix-command" "flakes" ];
  nixpkgs.config.allowUnfree = true;

  users.users.ocean = {
    isNormalUser = true;
    description = "ocean";
    initialPassword = "1234";
    shell = pkgs.fish;
    extraGroups = [
      "wheel"
      "networkmanager"
      "video"
      "audio"
      "input"
    ];
  };

  security.polkit.enable = true;
  security.rtkit.enable = true;

  services.openssh.enable = true;
  services.printing.enable = false;

  hardware.graphics = {
    enable = true;
    enable32Bit = true;
  };

  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    wireplumber.enable = true;
  };

  programs.fish.enable = true;
  programs.firefox.enable = false;

  # Minimal system packages; apps go to home-manager.
  environment.systemPackages = with pkgs; [
    git
    wget
  ];

  system.stateVersion = "25.05";
}
