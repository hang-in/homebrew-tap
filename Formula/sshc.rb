class Sshc < Formula
  desc "Minimal TUI for managing and connecting to SSH hosts defined in ~/.ssh/config"
  homepage "https://github.com/hang-in/sshc"
  version "0.9.0"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/hang-in/sshc/releases/download/v0.9.0/sshc-aarch64-apple-darwin.tar.xz"
      sha256 "a74291f8f39656c48584b04c0df392414fd0a2a9849efda999090f00bf265f16"
    end
    if Hardware::CPU.intel?
      url "https://github.com/hang-in/sshc/releases/download/v0.9.0/sshc-x86_64-apple-darwin.tar.xz"
      sha256 "8cedba9d2081972ba70c46f50a8fce41055a2e64162c077162aeb9907981a423"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/hang-in/sshc/releases/download/v0.9.0/sshc-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "0c50bb360965ffa3b65be3f487fc59480cf5191450f50189de5d32ca2739cced"
    end
    if Hardware::CPU.intel?
      url "https://github.com/hang-in/sshc/releases/download/v0.9.0/sshc-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "d312760c628aaac05eaa9954e1bf7a51adfc2205a711ae6960649fd6671f5aa0"
    end
  end
  license "MIT"

  BINARY_ALIASES = {
    "aarch64-apple-darwin":      {},
    "aarch64-pc-windows-gnu":    {},
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
