class Tunaround < Formula
  desc "로컬·LAN의 터미널 에이전트 세션을 토론·검색·A2A 작업 위임으로 묶는 사용자 주도 오케스트레이터(개인 도구)"
  homepage "https://github.com/hang-in/tunaRound"
  version "0.5.0"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/hang-in/tunaRound/releases/download/v0.5.0/tunaround-aarch64-apple-darwin.tar.xz"
      sha256 "9d8b011637a9f149b03f9802d09c955d8b8f19f80926da7bf966ca14b7c5e7a3"
    end
    if Hardware::CPU.intel?
      url "https://github.com/hang-in/tunaRound/releases/download/v0.5.0/tunaround-x86_64-apple-darwin.tar.xz"
      sha256 "63e0c65e6a2a45f319c82de2923ee0b384e0f474b7d9ed17bb7edf4589be024d"
    end
  end
  if OS.linux? && Hardware::CPU.intel?
    url "https://github.com/hang-in/tunaRound/releases/download/v0.5.0/tunaround-x86_64-unknown-linux-gnu.tar.xz"
    sha256 "5bace4f3be9c49b7775da10a498426389c532442fdc1d1df6b57d0957233cc70"
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
