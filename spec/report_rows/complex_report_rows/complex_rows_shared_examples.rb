# frozen_string_literal: true

RSpec.shared_examples 'complex_row' do
  it 'counts only expenses' do
    expect(@subject.countable_result).to eq @total_amount
  end

  it 'returns appropriate representation' do
    expect(@subject.printable_result).to eq @result_string
  end
end
