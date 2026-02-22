#!/usr/bin/env bash
set -euo pipefail

# This script is designed for:
# curl -fsSL <raw-bootstrap-url> | sudo bash
#
# Key design choices:
# 1) No git dependency at all (avoids sudo/root git path issues).
# 2) Use flake "path:" source so generated hardware config is always included.

REPO_OWNER="${REPO_OWNER:-ocean-sudo}"
REPO_NAME="${REPO_NAME:-nixos-surfacebook2}"
REPO_BRANCH="${REPO_BRANCH:-main}"
REPO_TARBALL_URL="${REPO_TARBALL_URL:-https://codeload.github.com/${REPO_OWNER}/${REPO_NAME}/tar.gz/refs/heads/${REPO_BRANCH}}"
TARGET_DIR="${TARGET_DIR:-/etc/nixos/nixos-surfacebook2}"
FLAKE_HOST="${FLAKE_HOST:-SurfaceBook2}"
HARDWARE_FILE_REL="${HARDWARE_FILE_REL:-hosts/SurfaceBook2/hardware-configuration.nix}"
BACKUP_EXISTING="${BACKUP_EXISTING:-1}"

log() {
  printf '[surfacebook2-bootstrap] %s\n' "$*"
}

die() {
  printf '[surfacebook2-bootstrap] ERROR: %s\n' "$*" >&2
  exit 1
}

require_cmd() {
  command -v "$1" >/dev/null 2>&1 || die "缺少命令: $1"
}

if [[ "$(id -u)" -ne 0 ]]; then
  die "请使用 root 运行。示例: curl -fsSL <raw-url> | sudo bash"
fi

require_cmd curl
require_cmd tar
require_cmd nixos-rebuild
require_cmd nixos-generate-config
require_cmd mktemp

tmp_dir="$(mktemp -d /tmp/nixos-surfacebook2-bootstrap.XXXXXX)"
cleanup() {
  rm -rf "$tmp_dir"
}
trap cleanup EXIT

archive="$tmp_dir/repo.tar.gz"
src_dir="$tmp_dir/src"

log "下载项目 tarball: $REPO_TARBALL_URL"
curl -fsSL "$REPO_TARBALL_URL" -o "$archive"

mkdir -p "$src_dir"
tar -xzf "$archive" -C "$src_dir" --strip-components=1

[[ -f "$src_dir/flake.nix" ]] || die "下载内容不是有效 flake 项目（缺少 flake.nix）"

if [[ -e "$TARGET_DIR" ]]; then
  if [[ "$BACKUP_EXISTING" == "1" ]]; then
    backup="${TARGET_DIR}.bak.$(date +%Y%m%d%H%M%S)"
    mv "$TARGET_DIR" "$backup"
    log "检测到已有目录，已备份为: $backup"
  else
    rm -rf "$TARGET_DIR"
    log "检测到已有目录，已删除: $TARGET_DIR"
  fi
fi

mkdir -p "$TARGET_DIR"
cp -a "$src_dir"/. "$TARGET_DIR"/
chown -R root:root "$TARGET_DIR"
log "项目已部署到: $TARGET_DIR"

hardware_file="$TARGET_DIR/$HARDWARE_FILE_REL"
mkdir -p "$(dirname "$hardware_file")"
nixos-generate-config --show-hardware-config > "$hardware_file"
log "已生成硬件配置: $hardware_file"

log "开始应用系统配置: path:$TARGET_DIR#$FLAKE_HOST"
nixos-rebuild switch \
  --option extra-experimental-features "nix-command flakes" \
  --flake "path:${TARGET_DIR}#${FLAKE_HOST}"

log "完成。当前已启用 greetd（tuigreet）作为登录界面。"
