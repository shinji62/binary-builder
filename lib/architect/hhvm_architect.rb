require 'erb'

module BinaryBuilder
  class HHVMArchitect < Architect
    HHVM_TEMPLATE_PATH = File.expand_path('../../../templates/hhvm_blueprint.sh.erb', __FILE__)

    def blueprint
      Template.new(
        contents: read_file(HHVM_TEMPLATE_PATH),
        binary_version: binary_version,
        dependency_urls: debian_dependency_urls
      ).result
    end

    private

    def debian_dependency_urls
      # These dependencies are Ubuntu trusty specific!
      # You will need to change these when building
      # for a different RootFS

      [
        "http://dl.hhvm.com/ubuntu/pool/main/h/hhvm/hhvm_#{binary_version}~trusty_amd64.deb",
        'http://mirrors.kernel.org/ubuntu/pool/main/b/boost1.54/libboost-filesystem1.54.0_1.54.0-4ubuntu3.1_amd64.deb',
        'http://mirrors.kernel.org/ubuntu/pool/main/b/boost1.54/libboost-program-options1.54.0_1.54.0-4ubuntu3.1_amd64.deb',
        'http://mirrors.kernel.org/ubuntu/pool/main/b/boost1.54/libboost-regex1.54.0_1.54.0-4ubuntu3.1_amd64.deb',
        'http://mirrors.kernel.org/ubuntu/pool/main/b/boost1.54/libboost-system1.54.0_1.54.0-4ubuntu3.1_amd64.deb',
        'http://mirrors.kernel.org/ubuntu/pool/main/b/boost1.54/libboost-thread1.54.0_1.54.0-4ubuntu3.1_amd64.deb',
        'http://mirrors.kernel.org/ubuntu/pool/universe/b/boost1.54/libboost-context1.54.0_1.54.0-4ubuntu3.1_amd64.deb',
        'http://mirrors.kernel.org/ubuntu/pool/main/g/google-glog/libgoogle-glog0_0.3.3-2_amd64.deb',
        'http://mirrors.kernel.org/ubuntu/pool/universe/j/jemalloc/libjemalloc1_3.6.0-3_amd64.deb',
        'http://mirrors.kernel.org/ubuntu/pool/universe/libo/libonig/libonig2_5.9.6-1_amd64.deb',
        'http://mirrors.kernel.org/ubuntu/pool/universe/t/tbb/libtbb2_4.2~20130725-1.1ubuntu1_amd64.deb',
        'http://mirrors.kernel.org/ubuntu/pool/main/g/gflags/libgflags2_2.0-2.1_amd64.deb',
        'http://mirrors.kernel.org/ubuntu/pool/main/libu/libunwind/libunwind8_1.1-3.2_amd64.deb',
        'http://mirrors.kernel.org/ubuntu/pool/main/g/gcc-4.9/libstdc++6_4.9.2-10ubuntu13_amd64.deb'
      ]
    end

    class Template
      def initialize(options)
        @erb                    = ERB.new(options[:contents])
        @binary_version         = (options[:binary_version])
        @debian_dependency_urls = (options[:dependency_urls])
      end

      attr_reader :binary_version, :debian_dependency_urls

      def result
        @erb.result(binding)
      end
    end
  end
end
