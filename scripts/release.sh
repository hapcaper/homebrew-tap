#!/usr/bin/env bash
# 发新版：上传 DMG 到 Releases + 更新 cask 里的 version / sha256
# 用法：scripts/release.sh <版本号> <DMG 路径>
# 例：  scripts/release.sh 1.2 ~/Code/Myself/oneTool/dist/oneTool-1.2.dmg
set -euo pipefail

VERSION="${1:?用法: release.sh <版本号> <DMG 路径>}"
DMG="${2:?用法: release.sh <版本号> <DMG 路径>}"
ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
REPO="hapcaper/homebrew-tap"

[ -f "$DMG" ] || { echo "✗ 找不到 DMG：$DMG"; exit 1; }
SHA=$(shasum -a 256 "$DMG" | awk '{print $1}')

gh release create "v$VERSION" "$DMG" --repo "$REPO" \
    --title "oneTool $VERSION" --notes "oneTool $VERSION"

# cask 的 url 用 v#{version} 拼接，这里只需同步版本号与 sha256
sed -i '' \
    -e "s|^  version \".*\"$|  version \"$VERSION\"|" \
    -e "s|^  sha256 \".*\"$|  sha256 \"$SHA\"|" \
    "$ROOT/Casks/onetool.rb"

git -C "$ROOT" add Casks/onetool.rb
git -C "$ROOT" commit -m "onetool $VERSION"
git -C "$ROOT" push

echo "✓ 已发布：https://github.com/$REPO/releases/tag/v$VERSION"
