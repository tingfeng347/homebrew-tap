# frozen_string_literal: true

# Install the macOS toolkit and its shell entry points.
class Mactools < Formula
  desc "macOS terminal toolkit for Homebrew packages and AI coding tools"
  homepage "https://github.com/tingfeng347/mactools"
  url "https://github.com/tingfeng347/mactools/archive/refs/tags/v0.1.17.tar.gz"
  sha256 "f039c6e1a3d21acd69fe7d94546b9441b2c973cb518e09a6c1862d12569ded93"
  license "GPL-3.0-only"

  depends_on "fzf"
  depends_on :macos
  depends_on "python@3.14"

  def install
    libexec.install "bin"
    (libexec/"python-bin").install_symlink formula_opt_bin("python@3.14")/"python3.14" => "python3"
    commands = %w[ma maci macr macu macd macc maco macm maca]
    commands.each do |command|
      (bin/command).write_env_script libexec/"bin"/command,
                                     PATH: "#{libexec}/python-bin:#{formula_opt_bin("fzf")}:$PATH"
    end

    generate_completions_from_executable(bin/"ma", "completion")
    zsh_script = (zsh_completion/"_ma").read
    (zsh_completion/"_ma").atomic_write "#compdef #{commands.join(" ")}\n#{zsh_script}\n_mactools_complete \"$@\"\n"
    commands.drop(1).each do |command|
      bash_completion.install_symlink bash_completion/"ma" => command
      zsh_completion.install_symlink zsh_completion/"_ma" => "_#{command}"
      fish_completion.install_symlink fish_completion/"ma.fish" => "#{command}.fish"
    end
  end

  test do
    ENV["XDG_CONFIG_HOME"] = testpath/"config"
    ENV["XDG_CACHE_HOME"] = testpath/"cache"
    ENV["MACTOOLS_LANG"] = "en"
    assert_match "mactools #{version}", shell_output("#{bin}/ma --version")
    assert_match "Usage:", shell_output("#{bin}/ma --help")
    assert_path_exists libexec/"bin/mactools_mole.zip"
    assert_path_exists libexec/"bin/mactools_apps.py"
    assert_path_exists libexec/"bin/mactools_optimize.py"
    assert_match "browser-cache", shell_output("#{bin}/ma clean --exact browser-cache --list")
    assert_match "network-optimization", shell_output("#{bin}/ma optimize --list")
    assert_match "--apps", shell_output("#{bin}/macr --help")
    assert_match "--scan-timeout", shell_output("#{bin}/macr --help")
    assert_match "--clean-leftovers", shell_output("#{bin}/macr --help")
    %w[maci macr macu macd macc maco macm maca].each do |command|
      assert_match "--help", shell_output("#{bin}/#{command} --help")
    end
    %w[bash zsh fish].each do |shell|
      assert_match "maci", shell_output("#{bin}/ma completion #{shell}")
    end
  end
end
