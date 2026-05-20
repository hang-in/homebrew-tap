class Sshc < Formula
  desc "Minimal TUI for managing and connecting to SSH hosts defined in ~/.ssh/config"
  homepage "https://github.com/hang-in/sshc"
  version "0.4.3"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/hang-in/sshc/releases/download/v0.4.3/sshc-aarch64-apple-darwin.tar.xz"
      sha256 "8c25a6d68ae2628a7255c01507bf2e4f544ce1e3ad8b3d331897b5b6411c9159"
    end
    if Hardware::CPU.intel?
      url "https://github.com/hang-in/sshc/releases/download/v0.4.3/sshc-x86_64-apple-darwin.tar.xz"
      sha256 "2526b35b3d9e5a3ed1dc9617af57b4482e09981dbadf0ba865c0e77ddbee5b78"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/hang-in/sshc/releases/download/v0.4.3/sshc-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "66f97988af708449ca8f4a070323d29d2361bc1c9e9b4fe3d1b7d6d90185655d"
    end
    if Hardware::CPU.intel?
      url "https://github.com/hang-in/sshc/releases/download/v0.4.3/sshc-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "c7e2ef2d4b1486b5babf727e0709254d9e9515849f9d32c3661f3ff7c57e6aa2"
    end
  end
  license "MIT"

  BINARY_ALIASES = {
    "aarch64-apple-darwin":      {},
    "aarch64-unknown-linux-gnu": {},
    "x86_64-apple-darwin":       {},
    "x86_64-unknown-linux-gnu":  {},
  }.freeze

  def target_triple
    cpu = Hardware::CPU.arm? ? "aarch64" : "x86_64"
    os = OS.mac? ? "apple-darwin" : "unknown-linux-gnu"

    "#{cpu}-#{os}"
  end

  def install_binary_aliases!
    BINARY_ALIASES[target_triple.to_sym].each do |source, dests|
      dests.each do |dest|
        bin.install_symlink bin/source.to_s => dest
      end
    end
  end

  def install
    bin.install "sshc" if OS.mac? && Hardware::CPU.arm?
    bin.install "sshc" if OS.mac? && Hardware::CPU.intel?
    bin.install "sshc" if OS.linux? && Hardware::CPU.arm?
    bin.install "sshc" if OS.linux? && Hardware::CPU.intel?

    install_binary_aliases!

    # Homebrew will automatically install these, so we don't need to do that
    doc_files = Dir["README.*", "readme.*", "LICENSE", "LICENSE.*", "CHANGELOG.*"]
    leftover_contents = Dir["*"] - doc_files

    # Install any leftover files in pkgshare; these are probably config or
    # sample files.
    pkgshare.install(*leftover_contents) unless leftover_contents.empty?
  end
end
