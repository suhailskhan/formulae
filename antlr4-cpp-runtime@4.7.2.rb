class Antlr4CppRuntimeAT472 < Formula
  desc "ANother Tool for Language Recognition C++ Runtime Library"
  homepage "https://www.antlr.org/"
  url "https://www.antlr.org/download/antlr4-cpp-runtime-4.7.2-source.zip"
  sha256 "8631a39116684638168663d295a969ad544cead3e6089605a44fea34ec01f31a"

  livecheck do
    url "https://www.antlr.org/download.html"
    regex(/href=.*?antlr4-cpp-runtime[._-]v?(\d+(?:\.\d+)+)-source\.zip/i)
  end

  depends_on "cmake" => :build

  on_linux do
    depends_on "pkg-config" => :build
    depends_on "util-linux"
  end

  fails_with gcc: "5"

  def install
    system "cmake", ".", "-DANTLR4_INSTALL=ON", "-DANTLR_BUILD_CPP_TESTS=OFF", *std_cmake_args
    system "cmake", "--build", ".", "--target", "install"
  end

  test do
    (testpath/"test.cc").write <<~EOS
      #include <antlr4-runtime.h>
      int main(int argc, const char* argv[]) {
          try {
              throw antlr4::ParseCancellationException() ;
          } catch (antlr4::ParseCancellationException &exception) {
              /* ignore */
          }
          return 0 ;
      }
    EOS
    system ENV.cxx, "-std=c++11", "-I#{include}/antlr4-runtime", "test.cc",
                        "-L#{lib}", "-lantlr4-runtime", "-o", "test"
    system "./test"
  end
end
