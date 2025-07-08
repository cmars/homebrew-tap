class Stigmerge < Formula
  desc "Anonymous decentralized file distribution and transfer"
  homepage "https://github.com/cmars/stigmerge"
  version "0.5.2"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/cmars/stigmerge/releases/download/stigmerge-v0.5.2/stigmerge-aarch64-apple-darwin.tar.gz"
      sha256 "ae6d2a87a2aa159fab809147e8a56fcb4a35a1c7e4449ba29366e4b43388b558"
    end
    if Hardware::CPU.intel?
      url "https://github.com/cmars/stigmerge/releases/download/stigmerge-v0.5.2/stigmerge-x86_64-apple-darwin.tar.gz"
      sha256 "c9e06d6366d7b2d648de76a23a8e78048f60c2707b2bfc4e1ad9526fa0041495"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/cmars/stigmerge/releases/download/stigmerge-v0.5.2/stigmerge-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "1e9b78f4521ab5ca0e17b74985b9a727be284279e512a71d1bba25273589700d"
    end
    if Hardware::CPU.intel?
      url "https://github.com/cmars/stigmerge/releases/download/stigmerge-v0.5.2/stigmerge-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "5d43cdfcc7f1bd2ac6be1612f4bd379ade1513d694552380a5e67120b593f4d7"
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
    bin.install "stigmerge" if OS.mac? && Hardware::CPU.arm?
    bin.install "stigmerge" if OS.mac? && Hardware::CPU.intel?
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
