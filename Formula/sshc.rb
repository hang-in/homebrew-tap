class Sshc < Formula
  desc "Minimal TUI for managing and connecting to SSH hosts defined in ~/.ssh/config"
  homepage "https://github.com/hang-in/sshc"
  version "0.7.3"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/hang-in/sshc/releases/download/v0.7.3/sshc-aarch64-apple-darwin.tar.xz"
      sha256 "ea3fe3bf901a5f04b4afaccbf58eb567dbf62b0452ebbc5584820e9d3c7dbd72"
    end
    if Hardware::CPU.intel?
      url "https://github.com/hang-in/sshc/releases/download/v0.7.3/sshc-x86_64-apple-darwin.tar.xz"
      sha256 "bfc063f2fdda53ae8a406dafa5f5f5b49975f75ac20a4ed5e8e1998d199298f2"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/hang-in/sshc/releases/download/v0.7.3/sshc-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "5f6ffe276678ccfe1cf9b1806163b58be0bcd0eec198db68e64fc0b56df94a77"
    end
    if Hardware::CPU.intel?
      url "https://github.com/hang-in/sshc/releases/download/v0.7.3/sshc-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "46d6a47faee195239a4a1dc2f54bbb8ecae4cb9bddae4f2fc0c27867a917d485"
    end
  end
  license "MIT"

  BINARY_ALIASES = {
    "aarch64-apple-darwin":      {},
    "aarch64-unknown-linux-gnu": {},
    "x86_64-apple-darwin":       {},
    "x86_64-pc-windows-gnu":     {},
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
