class DistransCli < Formula
  desc "Anonymous decentralized file distribution and transfer"
  homepage "https://github.com/cmars/distrans"
  version "0.3.13"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/cmars/distrans/releases/download/distrans_cli-v0.3.13/distrans_cli-aarch64-apple-darwin.tar.gz"
      sha256 "5c5e4b3428728e1d9ec71b0c6ac143e3e36c921a49c78c93d7e8de8539b3bb3a"
    end
    if Hardware::CPU.intel?
      url "https://github.com/cmars/distrans/releases/download/distrans_cli-v0.3.13/distrans_cli-x86_64-apple-darwin.tar.gz"
      sha256 "9822127aaba23c0d166dff703d95948b610f6beb8b8db63c16dd28381c12929a"
    end
  end
  if OS.linux?
    if Hardware::CPU.intel?
      url "https://github.com/cmars/distrans/releases/download/distrans_cli-v0.3.13/distrans_cli-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "a56d400c137d64997b1278554fb078d53a6bab00e6656d7d9dfd3f3eba9bad92"
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
