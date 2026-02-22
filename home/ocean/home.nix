{ pkgs, inputs, ... }:
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

  # Keep Niri/Noctalia as editable dotfiles managed declaratively via home.file.
  home.file.".config/niri" = {
    source = ./.config/niri;
    recursive = true;
  };

  home.file.".config/noctalia" = {
    source = ./.config/noctalia;
    recursive = true;
  };

  home.file.".config/nvim" = {
    source = ./.config/nvim;
    recursive = true;
  };
}
