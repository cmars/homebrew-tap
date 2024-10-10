class DistransCli < Formula
  desc "Anonymous decentralized file distribution and transfer"
  homepage "https://github.com/cmars/distrans"
  version "0.3.10"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/cmars/distrans/releases/download/distrans_cli-v0.3.10/distrans_cli-aarch64-apple-darwin.tar.gz"
      sha256 "98b8034de97459ea3deb1f28cd5fc83395ca6603910e96de8dbc04a9fef14895"
    end
    if Hardware::CPU.intel?
      url "https://github.com/cmars/distrans/releases/download/distrans_cli-v0.3.10/distrans_cli-x86_64-apple-darwin.tar.gz"
      sha256 "42b38a82b96bb2cfcfbb7e3203be7d3da2c7f7c5d126a2a1118d32c3b9ed0bfa"
    end
  end
  if OS.linux?
    if Hardware::CPU.intel?
      url "https://github.com/cmars/distrans/releases/download/distrans_cli-v0.3.10/distrans_cli-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "3a707daa640d607c3594f3dc6b2f8d28dc119a04b70426de19443f6a86fc74ee"
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
