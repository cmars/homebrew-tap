class Stigmerge < Formula
  desc "Anonymous decentralized file distribution and transfer"
  homepage "https://github.com/cmars/stigmerge"
  version "0.4.3"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/cmars/stigmerge/releases/download/stigmerge-v0.4.3/stigmerge-aarch64-apple-darwin.tar.gz"
      sha256 "fd894a0e399251b7a419e1770dd4341d194ea208e9659e24b736d54dd58f7cc4"
    end
    if Hardware::CPU.intel?
      url "https://github.com/cmars/stigmerge/releases/download/stigmerge-v0.4.3/stigmerge-x86_64-apple-darwin.tar.gz"
      sha256 "33b670ca016df9aaf680ec02b2b5b5a8818590b776961cf951d1452c51b81005"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/cmars/stigmerge/releases/download/stigmerge-v0.4.3/stigmerge-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "0e01be58d0c4ec44e2fc15caa1a7b4527cf06038e8ed20099162358dca830ddb"
    end
    if Hardware::CPU.intel?
      url "https://github.com/cmars/stigmerge/releases/download/stigmerge-v0.4.3/stigmerge-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "4a90a7dc7fca9307525334210781bcadb9c5c1f0e2be78d9e8e5633c794f42cb"
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
