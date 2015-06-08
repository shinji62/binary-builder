require 'spec_helper'

module BinaryBuilder
  describe HHVMArchitect do
    subject(:architect) { HHVMArchitect.new(binary_version: binary_version) }
    let(:debian_dependency_urls) { Array.new }
    before do
      allow(architect).to receive(:debian_dependency_urls).and_return debian_dependency_urls
    end

    context 'when building the hhvm package' do
      let(:binary_version) { '3.6.0' }

      describe 'the blueprint' do
        it 'should have the correct BINARY_VERSION value' do
          expect(architect.blueprint).to include 'HHVM_VERSION=3.6.0'
        end

        context 'the external debian libraries' do
          let(:debian_dependency_urls) do
            [
              'http://fun.house.mirrors.edu/ubuntu/meatball.deb',
              'http://fun.house.mirrors.edu/ubuntu/banana.deb'
            ]
          end

          it 'should be retrieved in the blueprint' do
            expect(architect.blueprint).to include "wget -nv #{debian_dependency_urls[0]}"
            expect(architect.blueprint).to include "wget -nv #{debian_dependency_urls[1]}"
          end

          it 'should be extracted into the hhvm directory' do
            expect(architect.blueprint).to include "dpkg -x $(basename #{debian_dependency_urls[0]}) $HHVM_DIR"
            expect(architect.blueprint).to include "dpkg -x $(basename #{debian_dependency_urls[1]}) $HHVM_DIR"
          end
        end

      end
    end
  end
end
