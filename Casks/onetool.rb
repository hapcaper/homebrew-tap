cask "onetool" do
  version "1.7.0"
  sha256 "fbdc97c61e01aed8d110b797972d56983aa4b0a2f50d861be350961d1275389a"

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
