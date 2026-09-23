#!/usr/bin/env bash
# 发新版：上传 DMG 到 Releases + 更新 cask 里的 version / sha256
# 用法：scripts/release.sh <版本号> <DMG 路径>
# 例：  HTTPS_PROXY=http://127.0.0.1:7897 scripts/release.sh 1.2 ~/Code/Myself/oneTool/dist/oneTool-1.2.dmg
# （HTTPS_PROXY 只供最后的 git push 用——github.com 直连不通；gh 上传反而要直连，脚本会自动剥掉代理变量）
set -euo pipefail

VERSION="${1:?用法: release.sh <版本号> <DMG 路径>}"
DMG="${2:?用法: release.sh <版本号> <DMG 路径>}"
ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
REPO="hapcaper/homebrew-tap"

[ -f "$DMG" ] || { echo "✗ 找不到 DMG：$DMG"; exit 1; }
SHA=$(shasum -a 256 "$DMG" | awk '{print $1}')

# 资产上传走直连：实测走代理会卡死（api/uploads.github.com 本身直连可达）
env -u HTTPS_PROXY -u HTTP_PROXY -u ALL_PROXY -u https_proxy -u http_proxy -u all_proxy \
    gh release create "v$VERSION" "$DMG" --repo "$REPO" \
    --title "oneTool $VERSION" --notes "oneTool $VERSION"

# cask 的 url 用 v#{version} 拼接，这里只需同步版本号与 sha256
sed -i '' \
    -e "s|^  version \".*\"$|  version \"$VERSION\"|" \
    -e "s|^  sha256 \".*\"$|  sha256 \"$SHA\"|" \
    "$ROOT/Casks/onetool.rb"

git -C "$ROOT" add Casks/onetool.rb
git -C "$ROOT" commit -m "onetool $VERSION"
GIT_PROXY=()
[ -n "${HTTPS_PROXY:-}" ] && GIT_PROXY=(-c "http.proxy=$HTTPS_PROXY")
git -C "$ROOT" "${GIT_PROXY[@]}" push

echo "✓ 已发布：https://github.com/$REPO/releases/tag/v$VERSION"
