class Tunaround < Formula
  desc "터미널에서 사람이 운전하는 역할 부여 2-에이전트 착수 전 설계 토론 도구"
  homepage "https://github.com/hang-in/tunaRound"
  version "0.2.0"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/hang-in/tunaRound/releases/download/v0.2.0/tunaround-aarch64-apple-darwin.tar.xz"
      sha256 "4811015295889fab58bc430c7804d83f0d93ad230e76eb5c138ec605686f9474"
    end
    if Hardware::CPU.intel?
      url "https://github.com/hang-in/tunaRound/releases/download/v0.2.0/tunaround-x86_64-apple-darwin.tar.xz"
      sha256 "305ee4f40359d96a6bfb7bed7d37481f58cf9eafa8c41093833175c592e0b0dd"
    end
  end
  if OS.linux? && Hardware::CPU.intel?
    url "https://github.com/hang-in/tunaRound/releases/download/v0.2.0/tunaround-x86_64-unknown-linux-gnu.tar.xz"
    sha256 "5ee412dc255dcacca85dd449fbc8a0eff8eada52c0f688cc09fbdd66af92e883"
  end
  license "AGPL-3.0-only"

  BINARY_ALIASES = {
    "aarch64-apple-darwin":     {},
    "x86_64-apple-darwin":      {},
    "x86_64-pc-windows-gnu":    {},
    "x86_64-unknown-linux-gnu": {},
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
    bin.install "tunaround" if OS.mac? && Hardware::CPU.arm?
    bin.install "tunaround" if OS.mac? && Hardware::CPU.intel?
    bin.install "tunaround" if OS.linux? && Hardware::CPU.intel?

    install_binary_aliases!

    # Homebrew will automatically install these, so we don't need to do that
    doc_files = Dir["README.*", "readme.*", "LICENSE", "LICENSE.*", "CHANGELOG.*"]
    leftover_contents = Dir["*"] - doc_files

    # Install any leftover files in pkgshare; these are probably config or
    # sample files.
    pkgshare.install(*leftover_contents) unless leftover_contents.empty?
  end
end
