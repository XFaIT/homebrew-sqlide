# Homebrew formula for sqlide. Installs the published wheels from PyPI into a virtualenv
# (no compiling of the Python dependencies, so the install is fast).
class Sqlide < Formula
  include Language::Python::Virtualenv

  desc "Terminal SQL IDE (DataGrip-like) over JDBC"
  homepage "https://github.com/XFaIT/sqlide"
  url "https://files.pythonhosted.org/packages/d0/74/4542a051610b66ccdf639c424a45b6a02a61004c730f29ebe88ea56329a1/sqlide-0.3.2.tar.gz"
  sha256 "7ed0542adc6326d20265e94db8c167f05a58203cd63b5a5b64e8d20ba0a94982"
  license "MIT"

  depends_on "openjdk"
  depends_on "python@3.12"

  def install
    venv = virtualenv_create(libexec, "python3.12")
    system venv.root/"bin/python", "-m", "pip", "install", "--only-binary=:all:", "sqlide==#{version}"
    # keg-only openjdk is not on PATH: point sqlide at it
    java_home = if OS.mac?
      Formula["openjdk"].opt_libexec/"openjdk.jdk/Contents/Home"
    else
      Formula["openjdk"].opt_prefix
    end
    (bin/"sqlide").write_env_script libexec/"bin/sqlide", JAVA_HOME: java_home
  end

  test do
    assert_match "sqlide", shell_output("#{bin}/sqlide --version")
  end
end
