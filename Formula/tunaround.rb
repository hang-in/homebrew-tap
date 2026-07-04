class Tunaround < Formula
  desc "터미널에서 사람이 운전하는 역할 부여 2-에이전트 착수 전 설계 토론 도구"
  homepage "https://github.com/hang-in/tunaRound"
  version "0.2.2"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/hang-in/tunaRound/releases/download/v0.2.2/tunaround-aarch64-apple-darwin.tar.xz"
      sha256 "1eb122a8f951b3b586fef07e8388e7082844f6169d79b23392cbb70757c32877"
    end
    if Hardware::CPU.intel?
      url "https://github.com/hang-in/tunaRound/releases/download/v0.2.2/tunaround-x86_64-apple-darwin.tar.xz"
      sha256 "5aceb5259261bb50c9dc9b74ffa41a1089743970ce273d2e9215e6af0fcb7b55"
    end
  end
  if OS.linux? && Hardware::CPU.intel?
    url "https://github.com/hang-in/tunaRound/releases/download/v0.2.2/tunaround-x86_64-unknown-linux-gnu.tar.xz"
    sha256 "786fcbb6ddcf3a206b4f1a0e5d6bbd599577690c520da53a3ab82f97d6f14a23"
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
