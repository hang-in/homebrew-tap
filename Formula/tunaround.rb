class Tunaround < Formula
  desc "로컬·LAN의 터미널 에이전트 세션을 토론·검색·A2A 작업 위임으로 묶는 사용자 주도 오케스트레이터(개인 도구)"
  homepage "https://github.com/hang-in/tunaRound"
  version "0.6.0"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/hang-in/tunaRound/releases/download/v0.6.0/tunaround-aarch64-apple-darwin.tar.xz"
      sha256 "56b3e6c3e977962049fb2b9e8de0f4d438b8b1b3c6724a858ca98157fd25ae82"
    end
    if Hardware::CPU.intel?
      url "https://github.com/hang-in/tunaRound/releases/download/v0.6.0/tunaround-x86_64-apple-darwin.tar.xz"
      sha256 "2ae6445ca95a6ef8b791196a1b4a84c477ba6fdf9bc950f2f160e24efe1501ee"
    end
  end
  if OS.linux? && Hardware::CPU.intel?
    url "https://github.com/hang-in/tunaRound/releases/download/v0.6.0/tunaround-x86_64-unknown-linux-gnu.tar.xz"
    sha256 "751bb4b401c3766b4069b8a945cfeba4d186230e2fb0f551957be498e2f44731"
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
