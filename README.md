# homebrew-tap

oneTool 的 Homebrew 源。此仓只放 cask 与发行版 DMG，App 源码不公开。

## 安装

    brew install --cask hapcaper/tap/onetool

oneTool 未使用 Apple 开发者签名，首次打开会被 macOS 拦截一次（提示 "Apple 无法验证是否包含恶意软件"，这是系统对所有未签名 App 的正常提示）：

1. 双击打开一次，弹框点「完成」
2. 打开 系统设置 → 隐私与安全性 → 向下滚到「安全性」一节，点「仍要打开」

放行只需要一次，之后 `brew upgrade` 升级不用再操作。也可以在终端执行：

    xattr -dr com.apple.quarantine /Applications/oneTool.app

## 升级 / 卸载

    brew upgrade --cask onetool
    brew uninstall --cask onetool

## 发新版（维护者）

打包完成后（DMG 在 oneTool 仓库的 dist/ 下）：

    HTTPS_PROXY=http://127.0.0.1:7897 scripts/release.sh 1.2 ~/Code/Myself/oneTool/dist/oneTool-1.2.dmg

（`HTTPS_PROXY` 供脚本里的 `git push` 用，github.com 在部分网络需要代理；gh 的资产上传脚本会自动剥掉代理走直连。）

脚本会创建 v<版本号> Release、上传 DMG、更新 Casks/onetool.rb 的 version 与 sha256 并推送。
