class DistransCli < Formula
  desc "Anonymous decentralized file distribution and transfer"
  homepage "https://github.com/cmars/distrans"
  version "0.3.17"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/cmars/distrans/releases/download/distrans_cli-v0.3.17/distrans_cli-aarch64-apple-darwin.tar.gz"
      sha256 "72e90803e1d19cd2b547956954ef313cf9c63694fc8fa210f3258d66d715c17a"
    end
    if Hardware::CPU.intel?
      url "https://github.com/cmars/distrans/releases/download/distrans_cli-v0.3.17/distrans_cli-x86_64-apple-darwin.tar.gz"
      sha256 "eb83b5c3fa19e187a5055f15f2cd530d52219865a13f18d5653ad8642c54b971"
    end
  end
  if OS.linux? && Hardware::CPU.intel?
    url "https://github.com/cmars/distrans/releases/download/distrans_cli-v0.3.17/distrans_cli-x86_64-unknown-linux-gnu.tar.gz"
    sha256 "c8398d489a8bdc323a62c4d278bc56126cb67d009db33a678cc5981169b7d665"
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
