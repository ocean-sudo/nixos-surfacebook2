# nixos-surfacebook2

Minimal NixOS flake for Surface Book 2 (NVIDIA 1050) with:
- Niri
- Noctalia
- Zen Browser + qutebrowser
- kitty + fish + starship
- neovim (dotfile-managed)

## Structure
- `hosts/SurfaceBook2`: host-specific files
- `modules/common`: reusable minimal modules
- `home/ocean`: home-manager
- `home/ocean/.config`: dotfiles (`niri`, `noctalia`, `nvim`)

## Dotfile behavior
- Browser configs (`zen`, `qutebrowser`) are not declaratively overridden.
- `niri` / `noctalia` / `nvim` templates are seeded to `~/.config` and stay user-editable.
- `xdg-user-dirs` is pinned to English names (`Downloads`, `Pictures`, etc.) even with Chinese locale.

## Important
1. Initial user/password is `ocean / 1234`. Change it after first login.
2. Login manager is `greetd` (`tuigreet`) and is declared in `modules/common/niri-core.nix`.

## One-shot bootstrap (curl | bash)
```bash
curl -fsSL https://raw.githubusercontent.com/ocean-sudo/nixos-surfacebook2/main/scripts/bootstrap.sh | sudo bash
```

This bootstrap script:
- Downloads repo as tarball (no `git` dependency under sudo/root).
- Regenerates `hosts/SurfaceBook2/hardware-configuration.nix`.
- Applies config with `--flake path:/etc/nixos/nixos-surfacebook2#SurfaceBook2`.

That `path:` flake source avoids the classic issue where git-based flakes ignore untracked generated files.

## Manual build
```bash
sudo nixos-generate-config --show-hardware-config > hosts/SurfaceBook2/hardware-configuration.nix
sudo nixos-rebuild switch --flake "path:$(pwd)#SurfaceBook2"
```

## Bootstrap env overrides
```bash
# Use your own tarball URL/branch artifact
REPO_TARBALL_URL=... \
REPO_BRANCH=main \
TARGET_DIR=/etc/nixos/nixos-surfacebook2 \
FLAKE_HOST=SurfaceBook2 \
curl -fsSL <raw-bootstrap-url> | sudo -E bash
```
