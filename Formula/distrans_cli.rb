class DistransCli < Formula
  desc "Anonymous decentralized file distribution and transfer"
  homepage "https://github.com/cmars/distrans"
  version "0.3.16"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/cmars/distrans/releases/download/distrans_cli-v0.3.16/distrans_cli-aarch64-apple-darwin.tar.gz"
      sha256 "424dec889a9f38e9c260f910b1c964946f823955bede864aac568dbdba66b23c"
    end
    if Hardware::CPU.intel?
      url "https://github.com/cmars/distrans/releases/download/distrans_cli-v0.3.16/distrans_cli-x86_64-apple-darwin.tar.gz"
      sha256 "6990565691fa275e64f1a77a181d19189e8b7ae3a684c0aacdf34b59ea6435c7"
    end
  end
  if OS.linux? && Hardware::CPU.intel?
    url "https://github.com/cmars/distrans/releases/download/distrans_cli-v0.3.16/distrans_cli-x86_64-unknown-linux-gnu.tar.gz"
    sha256 "1575f9ad3e67965140873a2b008f9075fe9e5c8cecfeb0b1b227c1623f3bc4a1"
  end
  license "MPL-2.0"

  BINARY_ALIASES = {
    "aarch64-apple-darwin":              {},
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
