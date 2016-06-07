require 'spec_helper'

include Txdb

describe ConnectionString do
  describe '#string' do
    let(:options) do
      {
        username: 'janeway', password: 'borgsuck',
        host: 'voyager', port: 3306, name: 'stellar_cartography'
      }
    end

    it 'assembles the correct string for mysql2' do
      string = ConnectionString.new(options.merge(adapter: 'mysql2')).string
      expect(string).to eq('mysql2://janeway:borgsuck@voyager:3306/stellar_cartography')
    end

    it 'assembles the correct string for sqlite' do
      string = ConnectionString.new(options.merge(adapter: 'sqlite')).string
      expect(string).to eq('sqlite://stellar_cartography')
    end
  end
end
