class DistransCli < Formula
  desc "Anonymous decentralized file distribution and transfer"
  homepage "https://github.com/cmars/distrans"
  version "0.3.4"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/cmars/distrans/releases/download/distrans_cli-v0.3.4/distrans_cli-aarch64-apple-darwin.tar.gz"
      sha256 "c73c493d9377aa29e58e844b0e82891fa4ccd6a938adc8a20f6e8dfa24a3eab1"
    end
    if Hardware::CPU.intel?
      url "https://github.com/cmars/distrans/releases/download/distrans_cli-v0.3.4/distrans_cli-x86_64-apple-darwin.tar.gz"
      sha256 "e7c5202157f039e949c88651e57f9eabf615d2b8ce35b33006ca21693a116050"
    end
  end
  if OS.linux?
    if Hardware::CPU.intel?
      url "https://github.com/cmars/distrans/releases/download/distrans_cli-v0.3.4/distrans_cli-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "40be5f9fd78777a299c1102c6ca20962e89a828323d20add810a8d2328b082d4"
    end
  end
  license "MPL-2.0"

  BINARY_ALIASES = {"aarch64-apple-darwin": {}, "x86_64-apple-darwin": {}, "x86_64-pc-windows-gnu": {}, "x86_64-unknown-linux-gnu": {}, "x86_64-unknown-linux-musl-dynamic": {}, "x86_64-unknown-linux-musl-static": {}}

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
    if OS.mac? && Hardware::CPU.arm?
      bin.install "distrans"
    end
    if OS.mac? && Hardware::CPU.intel?
      bin.install "distrans"
    end
    if OS.linux? && Hardware::CPU.intel?
      bin.install "distrans"
    end

    install_binary_aliases!

    # Homebrew will automatically install these, so we don't need to do that
    doc_files = Dir["README.*", "readme.*", "LICENSE", "LICENSE.*", "CHANGELOG.*"]
    leftover_contents = Dir["*"] - doc_files

    # Install any leftover files in pkgshare; these are probably config or
    # sample files.
    pkgshare.install(*leftover_contents) unless leftover_contents.empty?
  end
end
