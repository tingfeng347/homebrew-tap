cask "mactools-gui" do
  version "0.1.19"
  sha256 "5c13d6afc1df2e60530237b72f28a30fd4fc168c8f07694f172673f9f6b593c4"

  url "https://github.com/tingfeng347/mactools/releases/download/v#{version}/mactools_#{version}_universal.dmg"
  name "mactools"
  desc "Desktop GUI for the mactools terminal toolkit"
  homepage "https://github.com/tingfeng347/mactools"

  depends_on formula: "tingfeng347/tap/mactools"
  depends_on :macos

  app "mactools.app"

  # The DMG is not signed or notarized, so the app would otherwise be blocked by
  # Gatekeeper with "damaged and can't be opened". Clear the quarantine flag on
  # install instead of asking every user to run xattr manually.
  postflight_steps do
    run "/usr/bin/xattr",
        args:         ["-dr", "com.apple.quarantine", "{{appdir}}/mactools.app"],
        must_succeed: false
  end
end
