# frozen_string_literal: true

RSpec.shared_examples 'tags_based_row' do |tags|
  before do
    rows_with_tags = RowFactory.new.create_list(rand(2..4), tags: tags, operation_type: 'Расход')
    other_rows = RowFactory.new.create_list(rand(2..4), tags: FFaker::Lorem.word)
    rows = rows_with_tags + other_rows

    @expenses_with_tags = rows_with_tags.inject(0) { |i, row| i + BigDecimal(row[7]) }
    @subject = described_class.new
    rows.each { |row| @subject.parse(row) }
  end

  it "counts only #{tags} expenses" do
    expect(@subject.countable_result).to eq @expenses_with_tags
  end

  it 'returns appropriate representation' do
    expect(
      @subject.printable_result
    ).to eq "#{tags} = #{@expenses_with_tags} # Заполняется суммой расходов за месяц с отметкой ##{tags}"
  end
end
