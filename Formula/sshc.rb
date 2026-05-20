# typed: false
# frozen_string_literal: true

class Sshc < Formula
  desc "Minimal TUI for managing and connecting to SSH hosts defined in ~/.ssh/config"
  homepage "https://github.com/hang-in/sshc"
  version "0.4.1"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/hang-in/sshc/releases/download/v0.4.1/sshc-aarch64-apple-darwin.tar.gz"
      sha256 "e561b5ba7436a04cf503ea4a1eb19ef71e91318b440eaa56c2d06eb2912ad2e0"
    end
    on_intel do
      # macos-13 runner is still queued at release time. Update the URL +
      # sha256 once the x86_64-apple-darwin tarball is attached.
      url "https://github.com/hang-in/sshc/releases/download/v0.4.1/sshc-x86_64-apple-darwin.tar.gz"
      sha256 "0000000000000000000000000000000000000000000000000000000000000000"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/hang-in/sshc/releases/download/v0.4.1/sshc-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "4b49dcb4215bca397023c1fda871f69bfe65f0fdbe6493bcdbb3354d849670a5"
    end
    on_intel do
      url "https://github.com/hang-in/sshc/releases/download/v0.4.1/sshc-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "8533af199299c153414f75ef9e3114d6c6e2bc0b0e32fdc6acbf483dc35907ad"
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
