class Stigmerge < Formula
  desc "Anonymous decentralized file distribution and transfer"
  homepage "https://github.com/cmars/stigmerge"
  version "0.5.7"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/cmars/stigmerge/releases/download/stigmerge-v0.5.7/stigmerge-aarch64-apple-darwin.tar.gz"
      sha256 "23d301b7fce7384711cac859d62550bd69688cc2c7fcdfe0588814e05d529b2a"
    end
    if Hardware::CPU.intel?
      url "https://github.com/cmars/stigmerge/releases/download/stigmerge-v0.5.7/stigmerge-x86_64-apple-darwin.tar.gz"
      sha256 "3836bd7a7d2086c13a38de026c74b1f85da0e61113951104c186764366166fc5"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/cmars/stigmerge/releases/download/stigmerge-v0.5.7/stigmerge-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "67e5ec1266f447256c529c6417748c618bb9b42c285b3ecf407ebb8450d65a1b"
    end
    if Hardware::CPU.intel?
      url "https://github.com/cmars/stigmerge/releases/download/stigmerge-v0.5.7/stigmerge-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "4169f3a70bcc89c5e40f0efcf443377523fb3053d01bec576ac6c960e32dd2b5"
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
