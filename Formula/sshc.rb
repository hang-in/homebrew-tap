class Sshc < Formula
  desc "Minimal TUI for managing and connecting to SSH hosts defined in ~/.ssh/config"
  homepage "https://github.com/hang-in/sshc"
  version "0.8.3"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/hang-in/sshc/releases/download/v0.8.3/sshc-aarch64-apple-darwin.tar.xz"
      sha256 "40b3216b431bf9e7f415116fabc46fc36d4d9fec5f206ec580a95f650d0f607c"
    end
    if Hardware::CPU.intel?
      url "https://github.com/hang-in/sshc/releases/download/v0.8.3/sshc-x86_64-apple-darwin.tar.xz"
      sha256 "e6a7e63d0975f9bca15a052b7ca5a35fbb6b05050468b1aab496ac669c5bca3d"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/hang-in/sshc/releases/download/v0.8.3/sshc-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "cfcc208968b6a4b3dd1b1b73fa9572abc7e303f2257cad7fadec4b843346954f"
    end
    if Hardware::CPU.intel?
      url "https://github.com/hang-in/sshc/releases/download/v0.8.3/sshc-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "6e097c826a3aa585496f1acca70b9746eab128c95a7962fee4bddbe5d952fe98"
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
