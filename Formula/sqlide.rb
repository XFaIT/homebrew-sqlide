# Homebrew formula for sqlide. Installs the published wheels from PyPI into a virtualenv
# (no compiling of the Python dependencies, so the install is fast).
class Sqlide < Formula
  include Language::Python::Virtualenv

  desc "Terminal SQL IDE (DataGrip-like) over JDBC"
  homepage "https://github.com/XFaIT/sqlide"
  url "https://files.pythonhosted.org/packages/55/ff/f3efd5578e2ad9f35e051a2ac63293f8e9c531b6e813345dc8314c5559bc/sqlide-0.3.3.tar.gz"
  sha256 "20291c5286dfbf7cacc03a412f60acc084e72edb6a974d1b35e968378bea201d"
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
