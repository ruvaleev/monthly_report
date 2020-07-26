# frozen_string_literal: true

RSpec.shared_examples 'simple_row' do |_account_name|
  describe '#printable_result' do
    it 'returns appropriate string' do
      expect(@subject.printable_result).to eq(@expected_result)
    end
  end
end
