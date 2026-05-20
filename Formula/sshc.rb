# typed: false
# frozen_string_literal: true

# Documentation: https://docs.brew.sh/Formula-Cookbook
class Sshc < Formula
  desc "Minimal TUI for managing and connecting to SSH hosts defined in ~/.ssh/config"
  homepage "https://github.com/hang-in/sshc"
  version "0.4.0"
  license "MIT"

  # NOTE: Pre-built binaries are produced by hang-in/sshc's release.yml
  # workflow. Until the first release with assets attached, the URL and
  # SHA256 below are placeholders — the bump-homebrew workflow rewrites
  # them on every new release.

  on_macos do
    on_arm do
      url "https://github.com/hang-in/sshc/releases/download/v0.4.0/sshc-aarch64-apple-darwin.tar.gz"
      sha256 "0000000000000000000000000000000000000000000000000000000000000000"
    end
    on_intel do
      url "https://github.com/hang-in/sshc/releases/download/v0.4.0/sshc-x86_64-apple-darwin.tar.gz"
      sha256 "0000000000000000000000000000000000000000000000000000000000000000"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/hang-in/sshc/releases/download/v0.4.0/sshc-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "0000000000000000000000000000000000000000000000000000000000000000"
    end
    on_intel do
      url "https://github.com/hang-in/sshc/releases/download/v0.4.0/sshc-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "0000000000000000000000000000000000000000000000000000000000000000"
    end
  end

  def install
    bin.install "sshc"
  end

  test do
    # sshc is a TUI that requires a tty; running it headless would hang.
    # Smoke-test that the binary was installed and is executable.
    assert_predicate bin/"sshc", :exist?
    assert_predicate bin/"sshc", :executable?
  end
end
