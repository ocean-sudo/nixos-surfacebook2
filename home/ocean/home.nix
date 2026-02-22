{ lib, pkgs, inputs, ... }:
{
  home.username = "ocean";
  home.homeDirectory = "/home/ocean";
  home.stateVersion = "25.05";

  programs.home-manager.enable = true;

  programs.fish.enable = true;

  programs.starship = {
    enable = true;
    enableFishIntegration = true;
  };

  programs.kitty = {
    enable = true;
    shellIntegration.enableFishIntegration = true;
  };

  home.packages = with pkgs; [
    neovim
    zen-browser
    qutebrowser
    inputs.noctalia.packages.${pkgs.stdenv.hostPlatform.system}.default
  ];

  home.sessionVariables = {
    BROWSER = "zen-browser";
    TERMINAL = "kitty";
    SHELL = "fish";
    EDITOR = "nvim";
  };

  # Force English XDG user directories even under zh_CN locale.
  xdg.userDirs = {
    enable = true;
    createDirectories = true;
    desktop = "$HOME/Desktop";
    documents = "$HOME/Documents";
    download = "$HOME/Downloads";
    music = "$HOME/Music";
    pictures = "$HOME/Pictures";
    publicShare = "$HOME/Public";
    templates = "$HOME/Templates";
    videos = "$HOME/Videos";
  };

  # Seed editable dotfiles into ~/.config.
  # If old Home Manager symlinks exist, replace them with real directories.
  home.activation.seedEditableDotfiles = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
    seed_dir() {
      local name="$1"
      local src="${./.config}/$name"
      local dst="$HOME/.config/$name"

      mkdir -p "$HOME/.config"

      if [ -L "$dst" ]; then
        rm -rf "$dst"
        cp -r "$src" "$dst"
        return
      fi

      if [ ! -e "$dst" ]; then
        cp -r "$src" "$dst"
      fi
    }

    seed_dir niri
    seed_dir noctalia
    seed_dir nvim
  '';
}
