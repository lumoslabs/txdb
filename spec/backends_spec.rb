require 'spec_helper'

include Txdb

describe Backends do
  around(:each) do |example|
    old_backends = Backends.all.dup
    Backends.all.clear
    example.run
    Backends.all.replace(old_backends)
  end

  describe '.register' do
    it 'adds a backend' do
      Backends.register(:foo, :bar)
      expect(Backends.all).to include(foo: :bar)
    end
  end

  describe '.get' do
    it "looks up a backend by it's name" do
      Backends.register(:foo, :bar)
      expect(Backends.get(:foo)).to eq(:bar)
    end

    it 'returns nil if no backend can be found' do
      expect(Backends.get(:foo)).to be_nil
    end
  end
end
