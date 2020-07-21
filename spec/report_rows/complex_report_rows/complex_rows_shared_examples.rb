# frozen_string_literal: true

RSpec.shared_examples 'complex_row' do
  it 'counts only expenses' do
    expect(@subject.countable_result).to eq @total_amount
  end

  describe '#printable_result' do
    it 'returns appropriate representation' do
      expect(@subject.printable_result).to eq @result_string
    end
  end

  describe '#total_printable_result' do
    it 'returns appropriate representation for total' do
      expect(@subject.total_printable_result).to eq @total_result_string
    end
  end
end
