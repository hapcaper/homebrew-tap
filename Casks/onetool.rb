cask "onetool" do
  version "1.4"
  sha256 "2c41463dd04749ab885ac59a7a935669d5c0a3e81de7f4b7e1ddd4b245fa8f69"

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
