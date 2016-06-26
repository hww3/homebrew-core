class Wartremover < Formula
  desc "Flexible Scala code linting tool"
  homepage "https://github.com/puffnfresh/wartremover"
  url "https://github.com/puffnfresh/wartremover/archive/v1.0.0.tar.gz"
  sha256 "b315b38ccb633c14c83ea699cb8d12fa8a7105e3c6b066b87c1b53e9eb95a043"
  head "https://github.com/puffnfresh/wartremover.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "c27c739dc9ff1d060888cf427a57d5e3dba9f6d11fd845b255f3ec084ab48bd7" => :el_capitan
    sha256 "7628645cb2ee8480966d01d28f1628163aba27095fb98902a8ce1d30667284b8" => :yosemite
    sha256 "ad332de35667d3e096c3f8fb6e98cbffdfadaed64b9d7bacd9453084f7bca817" => :mavericks
  end

  depends_on "sbt" => :build

  def install
    # Prevents sandbox violation
    ENV.java_cache
    system "sbt", "core/assembly"
    libexec.install Dir["core/target/scala-*/wartremover-assembly-*.jar"]
    bin.write_jar_script Dir[libexec/"wartremover-assembly-*.jar"][0], "wartremover"
  end

  test do
    (testpath/"foo").write <<-EOS.undent
      object Foo {
        def foo() {
          var msg = "Hello World"
          println(msg)
        }
      }
    EOS
    cmd = "#{bin}/wartremover -traverser org.wartremover.warts.Unsafe foo 2>&1"
    assert_match "var is disabled", shell_output(cmd, 1)
  end
end
