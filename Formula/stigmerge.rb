class Stigmerge < Formula
  desc "Anonymous decentralized file distribution and transfer"
  homepage "https://github.com/cmars/stigmerge"
  version "0.5.1"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/cmars/stigmerge/releases/download/stigmerge-v0.5.1/stigmerge-aarch64-apple-darwin.tar.gz"
      sha256 "ca5b1b2b8b510aad8e1632d82074d1597c0e77913bb17a59cfa26b8a6d70ebfa"
    end
    if Hardware::CPU.intel?
      url "https://github.com/cmars/stigmerge/releases/download/stigmerge-v0.5.1/stigmerge-x86_64-apple-darwin.tar.gz"
      sha256 "ee1b1eefa058ae546f0636bc9c9b3bdf1c63bc6d304cac99c0df191b88a5df1d"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/cmars/stigmerge/releases/download/stigmerge-v0.5.1/stigmerge-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "f2f49b72881c0c79e3c629e914ab427a2a61f29a3bad9cd11616ae9fea2791c6"
    end
    if Hardware::CPU.intel?
      url "https://github.com/cmars/stigmerge/releases/download/stigmerge-v0.5.1/stigmerge-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "580732334070e89fe2e68f1c548b8851bb08e5c9858dc950df18fd19bed9ae11"
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
