cask "onetool" do
  version "1.1"
  sha256 "23bc4af22fd5a4b8e9494c509441b3b734f2a28b33ee1cdde2b55b0278697c2b"

  url "https://github.com/hapcaper/homebrew-tap/releases/download/v#{version}/oneTool-#{version}.dmg"
  name "oneTool"
  desc "Menu bar clipboard manager with OCR, pin-to-screen and a drawing board"
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
