class DistransCli < Formula
  desc "Anonymous decentralized file distribution and transfer"
  homepage "https://github.com/cmars/distrans"
  version "0.3.19"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/cmars/distrans/releases/download/distrans_cli-v0.3.19/distrans_cli-aarch64-apple-darwin.tar.gz"
      sha256 "c1c436cb72878f48d76d571f211d054b205979092855538f47ccbeab8fedb2f5"
    end
    if Hardware::CPU.intel?
      url "https://github.com/cmars/distrans/releases/download/distrans_cli-v0.3.19/distrans_cli-x86_64-apple-darwin.tar.gz"
      sha256 "299ceef8efcf4a923c88424de5585fd1506c165c98478bb8b852cbf309fe51c7"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/cmars/distrans/releases/download/distrans_cli-v0.3.19/distrans_cli-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "a56b8644970331b54a7fc0727de68ee5015b08b06977dfa0917b2fe41f342301"
    end
    if Hardware::CPU.intel?
      url "https://github.com/cmars/distrans/releases/download/distrans_cli-v0.3.19/distrans_cli-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "6edbf3c13018ab4b7c58a4343307acf1e04c7059a97fca627faee612319e64b4"
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
