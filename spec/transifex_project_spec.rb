require 'spec_helper'
require 'spec_helpers/test_db'

include Txdb

describe TransifexProject, test_db: true do
  let(:database) do
    TestDb.setup do
      create_table(:foo) do
        primary_key :id
      end
    end
  end

  let(:project) { database.transifex_project }

  describe '#api' do
    it 'returns a transifex api instance' do
      expect(project.api).to be_a(Txgh::TransifexApi)
    end
  end
end
