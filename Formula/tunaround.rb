class Tunaround < Formula
  desc "로컬·LAN의 터미널 에이전트 세션을 토론·검색·A2A 작업 위임으로 묶는 사용자 주도 오케스트레이터(개인 도구)"
  homepage "https://github.com/hang-in/tunaRound"
  version "0.4.0"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/hang-in/tunaRound/releases/download/v0.4.0/tunaround-aarch64-apple-darwin.tar.xz"
      sha256 "37ab46ed4b11e4194cb8604b87a0e27f1d517043a300d219e61d7d9d0fe693f0"
    end
    if Hardware::CPU.intel?
      url "https://github.com/hang-in/tunaRound/releases/download/v0.4.0/tunaround-x86_64-apple-darwin.tar.xz"
      sha256 "c6d0f1c568ee56bda181065178a017080c908f8e54493f51e848845d171fa8d0"
    end
  end
  if OS.linux? && Hardware::CPU.intel?
    url "https://github.com/hang-in/tunaRound/releases/download/v0.4.0/tunaround-x86_64-unknown-linux-gnu.tar.xz"
    sha256 "d19f48a9676531f92ee8729cde70dffb8959acf89f9881b151aa91b84a851391"
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
