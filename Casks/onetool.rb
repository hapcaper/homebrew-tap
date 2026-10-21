cask "onetool" do
  version "1.5.0"
  sha256 "76da74a0e35090e636a0ab017a602d0d58e57b48134cabe2a0ebf244d496adfd"

  url "https://github.com/hapcaper/homebrew-tap/releases/download/v#{version}/oneTool-#{version}.dmg"
  name "oneTool"
  desc "Menu bar clipboard manager with OCR, translation and a drawing board"
  homepage "https://github.com/hapcaper/homebrew-tap"

  depends_on macos: :sonoma

  app "oneTool.app"

  zap trash: "~/Library/Application Support/oneTool"

  caveats <<~EOS
    oneTool 未使用 Apple 开发者签名，首次打开会被 macOS 拦截一次：
    打开 系统设置 → 隐私与安全性 → 点「仍要打开」
    （或终端执行：xattr -dr com.apple.quarantine /Applications/oneTool.app）
  EOS
end
