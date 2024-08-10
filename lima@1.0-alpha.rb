class LimaAT10Alpha < Formula
    desc "Linux virtual machines"
    homepage "https://lima-vm.io/"
    url "https://github.com/suhailskhan/lima/archive/refs/tags/v1.0-alpha.tar.gz"
    sha256 "5505b9e4ff2d0a19062b487595bcb3b9a58e8e2dbc41338248fb2d236d028854"
    license "Apache-2.0"
    head "https://github.com/suhailskhan/lima.git", branch: "master"
  
    depends_on "go" => :build
    depends_on "qemu"
  
    def install
      if build.head?
        system "make"
      else
        # VERSION has to be explicitly specified when building from tar.gz, as it does not contain git tags
        system "make", "VERSION=#{version}"
      end
  
      bin.install Dir["_output/bin/*"]
      share.install Dir["_output/share/*"]
  
      # Install shell completions
      generate_completions_from_executable(bin/"limactl", "completion", base_name: "limactl")
    end
  
    test do
      info = JSON.parse shell_output("#{bin}/limactl info")
      # Verify that the VM drivers are compiled in
      assert_includes info["vmTypes"], "qemu"
      assert_includes info["vmTypes"], "vz" if OS.mac? && MacOS.version >= :ventura
      # Verify that the template files are installed
      template_names = info["templates"].map { |x| x["name"] }
      assert_includes template_names, "default"
    end
  end
