class Ccls < Formula
  desc "A C/C++ language server"
  homepage "https://github.com/caioluders/ccls"
  url "https://github.com/caioluders/ccls.git", :tag => "xxx", :revision => "8c5c3afb6a80f610fafff81cc615d4da8633e11b"
  head "https://github.com/caioluders/ccls.git"

  option "with-build-debug", "Configures ccls to be built in debug mode"
  option "without-system-clang", "Downloading Clang from http://releases.llvm.org/ during the configure process"
  option "with-asan", "Compile with address sanitizers"

  depends_on "llvm@6" => :build
  depends_on "cmake" => :build 

  def install
    build_type = build.with?("build-debug") ? "debug" : "release"
    system_clang = build.with?("system-clang") ? "ON" : "OFF"
    asan = build.with?("asan") ? "ON" : "OFF"

    args = std_cmake_args + %W[
        -DSYSTEM_CLANG=#{system_clang}
        -DCMAKE_BUILD_TYPE=#{build_type.capitalize}
        -DASAN=#{asan}
    ]

    ENV.prepend_path "PATH", Formula["llvm"].opt_bin
    ENV.prepend_path "PATH", Formula["cmake"].opt_bin

    system "mkdir", "-p", "#{build_type}"
    system "cmake", *args, "-B#{build_type}", "-H."
    system "cmake", "--build", "#{build_type}" , "--target", "install"
  end

  test do
    system "ccls", "--test-unit"
  end
end
