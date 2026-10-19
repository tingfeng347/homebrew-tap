# frozen_string_literal: true

# Install the macOS toolkit and its shell entry points.
class Mactools < Formula
  desc "macOS terminal toolkit for Homebrew packages and AI coding tools"
  homepage "https://github.com/tingfeng347/mactools"
  url "https://github.com/tingfeng347/mactools/archive/refs/tags/v0.1.5.tar.gz"
  sha256 "ea169799b76afa094dc40889179f2bede78c48da318dc20704a3ce5fe271845e"

  depends_on "fzf"
  depends_on :macos
  depends_on "python@3.14"

  def install
    libexec.install "bin"
    (libexec/"python-bin").install_symlink formula_opt_bin("python@3.14")/"python3.14" => "python3"
    commands = %w[ma maci macr macu macd macc macm maca]
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
    %w[maci macr macu macd macc macm maca].each do |command|
      assert_match "--help", shell_output("#{bin}/#{command} --help")
    end
    %w[bash zsh fish].each do |shell|
      assert_match "maci", shell_output("#{bin}/ma completion #{shell}")
    end
  end
end
