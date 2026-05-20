class Sshc < Formula
  desc "Minimal TUI for managing and connecting to SSH hosts defined in ~/.ssh/config"
  homepage "https://github.com/hang-in/sshc"
  version "0.5.0"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/hang-in/sshc/releases/download/v0.5.0/sshc-aarch64-apple-darwin.tar.xz"
      sha256 "e3c19f00488a2db024722fb0ad9d82f9f4097520fffbd006d864a59758dcc824"
    end
    if Hardware::CPU.intel?
      url "https://github.com/hang-in/sshc/releases/download/v0.5.0/sshc-x86_64-apple-darwin.tar.xz"
      sha256 "2e62e42170561c37a7986b6124230a5181f545e4531968ee52cb0c8e4eda6445"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/hang-in/sshc/releases/download/v0.5.0/sshc-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "1c40214ccd1af4e1e5643fec4d7c396c4ba2dede3249385efa0bf9fb6dab8592"
    end
    if Hardware::CPU.intel?
      url "https://github.com/hang-in/sshc/releases/download/v0.5.0/sshc-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "e14fa3bdeb05c7198cf215f66e45f44973f3e218b5ffd36da2d6257eabd6c5fb"
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
