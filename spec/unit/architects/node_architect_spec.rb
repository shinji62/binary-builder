require 'spec_helper'

module BinaryBuilder
  describe NodeArchitect do
    subject(:architect) { NodeArchitect.new(binary_version: '0.12.2') }

    describe '#blueprint' do
      it 'adds the binary_version value' do
        expect(architect.blueprint).to include '0.12.2'
      end

      it 'uses nodejs.org as a resource' do
        expect(architect.blueprint).to include 'curl http://nodejs.org/dist/'
      end

      it 'does NOT use iojs.org as a resource' do
        expect(architect.blueprint).not_to include 'curl https://iojs.org/dist/'
      end
    end
  end
end
