class DistransCli < Formula
  desc "Anonymous decentralized file distribution and transfer"
  homepage "https://github.com/cmars/distrans"
  version "0.3.18"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/cmars/distrans/releases/download/distrans_cli-v0.3.18/distrans_cli-aarch64-apple-darwin.tar.gz"
      sha256 "6e208942de7ce1c645352051dd3b290a66595b724b3c564225a5d0118fc2261f"
    end
    if Hardware::CPU.intel?
      url "https://github.com/cmars/distrans/releases/download/distrans_cli-v0.3.18/distrans_cli-x86_64-apple-darwin.tar.gz"
      sha256 "10663bc23728a1c5dd4bee8331b930e0eb47d16e5d17d9a1e357cb750fef211b"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/cmars/distrans/releases/download/distrans_cli-v0.3.18/distrans_cli-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "2275d21fcac292232874b7b1f497a0666f5ba2c50143e1039df038b6b129b310"
    end
    if Hardware::CPU.intel?
      url "https://github.com/cmars/distrans/releases/download/distrans_cli-v0.3.18/distrans_cli-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "bbdba1506a8c9feaa5810df6070f869cd962dd6c3e44f3a9de089fddfacd076e"
    end
  end
  license "MPL-2.0"

  BINARY_ALIASES = {
    "aarch64-apple-darwin":              {},
    "aarch64-unknown-linux-gnu":         {},
    "x86_64-apple-darwin":               {},
    "x86_64-pc-windows-gnu":             {},
    "x86_64-unknown-linux-gnu":          {},
    "x86_64-unknown-linux-musl-dynamic": {},
    "x86_64-unknown-linux-musl-static":  {},
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
    bin.install "distrans" if OS.mac? && Hardware::CPU.arm?
    bin.install "distrans" if OS.mac? && Hardware::CPU.intel?
    bin.install "distrans" if OS.linux? && Hardware::CPU.arm?
    bin.install "distrans" if OS.linux? && Hardware::CPU.intel?

    install_binary_aliases!

    # Homebrew will automatically install these, so we don't need to do that
    doc_files = Dir["README.*", "readme.*", "LICENSE", "LICENSE.*", "CHANGELOG.*"]
    leftover_contents = Dir["*"] - doc_files

    # Install any leftover files in pkgshare; these are probably config or
    # sample files.
    pkgshare.install(*leftover_contents) unless leftover_contents.empty?
  end
end
