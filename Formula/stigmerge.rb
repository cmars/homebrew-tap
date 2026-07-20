class Stigmerge < Formula
  desc "Anonymous decentralized file distribution and transfer"
  homepage "https://github.com/cmars/stigmerge"
  version "0.6.3"
  if OS.mac? && Hardware::CPU.arm?
    url "https://github.com/cmars/stigmerge/releases/download/stigmerge-v0.6.3/stigmerge-aarch64-apple-darwin.tar.gz"
    sha256 "252619edd54f634ab655e3dae8c2596f85cb27cc091d60a0339a068356d4b75e"
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/cmars/stigmerge/releases/download/stigmerge-v0.6.3/stigmerge-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "9d92b22922070a4baf94299250313ad8d3f144e1cfc8a11eedbab83f8c79abc1"
    end
    if Hardware::CPU.intel?
      url "https://github.com/cmars/stigmerge/releases/download/stigmerge-v0.6.3/stigmerge-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "8070966b879ec4f49e9bef8e49c5b27d7f2af47af0330c25df4d254438885f08"
    end
  end
  license "MPL-2.0"

  BINARY_ALIASES = {
    "aarch64-apple-darwin":              {},
    "aarch64-unknown-linux-gnu":         {},
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
    bin.install "stigmerge" if OS.mac? && Hardware::CPU.arm?
    bin.install "stigmerge" if OS.linux? && Hardware::CPU.arm?
    bin.install "stigmerge" if OS.linux? && Hardware::CPU.intel?

    install_binary_aliases!

    # Homebrew will automatically install these, so we don't need to do that
    doc_files = Dir["README.*", "readme.*", "LICENSE", "LICENSE.*", "CHANGELOG.*"]
    leftover_contents = Dir["*"] - doc_files

    # Install any leftover files in pkgshare; these are probably config or
    # sample files.
    pkgshare.install(*leftover_contents) unless leftover_contents.empty?
  end
end
