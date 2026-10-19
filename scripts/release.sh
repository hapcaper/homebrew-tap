#!/usr/bin/env bash
# 发新版：更新 cask 的 version / sha256 → 推送 → 打 tag 并上传 DMG 到 Releases
# 用法：scripts/release.sh <版本号> <DMG 路径>
# 例：  HTTPS_PROXY=http://127.0.0.1:7897 scripts/release.sh 1.2 ~/Code/Myself/oneTool/dist/oneTool-1.2.dmg
# （HTTPS_PROXY 只供 git 网络操作用——github.com 直连不通；gh 上传反而要直连，脚本会自动剥掉代理变量）
set -euo pipefail

VERSION="${1:?用法: release.sh <版本号> <DMG 路径>}"
DMG="${2:?用法: release.sh <版本号> <DMG 路径>}"
ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
REPO="hapcaper/homebrew-tap"
TAG="v$VERSION"

[ -f "$DMG" ] || { echo "✗ 找不到 DMG：$DMG"; exit 1; }
SHA=$(shasum -a 256 "$DMG" | awk '{print $1}')

GIT_PROXY=()
[ -n "${HTTPS_PROXY:-}" ] && GIT_PROXY=(-c "http.proxy=$HTTPS_PROXY")

# 同名 tag 已存在就中止：gh release create 会复用旧 tag，把资产挂到历史提交上
if git -C "$ROOT" "${GIT_PROXY[@]}" ls-remote --exit-code --tags origin "refs/tags/$TAG" >/dev/null 2>&1; then
    echo "✗ 远端已存在 tag $TAG，拒绝覆盖"
    exit 1
fi

# cask 的 url 用 v#{version} 拼接，这里只需同步版本号与 sha256
sed -i '' \
    -e "s|^  version \".*\"$|  version \"$VERSION\"|" \
    -e "s|^  sha256 \".*\"$|  sha256 \"$SHA\"|" \
    "$ROOT/Casks/onetool.rb"

git -C "$ROOT" add Casks/onetool.rb
git -C "$ROOT" commit -m "onetool $VERSION"
TARGET=$(git -C "$ROOT" rev-parse HEAD)

git -C "$ROOT" "${GIT_PROXY[@]}" push

# 资产上传走直连：实测走代理会卡死（api/uploads.github.com 本身直连可达）
# --target 让 tag 落在 cask 提交上；默认会创建在远端当前 HEAD（上一版提交）
env -u HTTPS_PROXY -u HTTP_PROXY -u ALL_PROXY -u https_proxy -u http_proxy -u all_proxy \
    gh release create "$TAG" "$DMG" --repo "$REPO" --target "$TARGET" \
    --title "oneTool $VERSION" --notes "oneTool $VERSION"

echo "✓ 已发布：https://github.com/$REPO/releases/tag/$TAG"
