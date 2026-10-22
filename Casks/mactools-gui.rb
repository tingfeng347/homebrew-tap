cask "mactools-gui" do
  version "0.1.17"
  sha256 "288fd1606bec29ca4191a51b845ded3d032dd8dd0b6cf0e62d0dd455349103ab"

  url "https://github.com/tingfeng347/mactools/releases/download/v#{version}/mactools_#{version}_universal.dmg"
  name "mactools"
  desc "Desktop GUI for the mactools terminal toolkit"
  homepage "https://github.com/tingfeng347/mactools"

  depends_on formula: "tingfeng347/tap/mactools"
  depends_on :macos

  app "mactools.app"
end
