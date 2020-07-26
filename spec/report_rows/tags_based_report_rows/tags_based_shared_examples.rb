# frozen_string_literal: true

RSpec.shared_examples 'tags_based_row' do |tags|
  before do
    @tag_body = BaseReportRow::TAGS[tags.to_sym]
    rows_with_tags = RowFactory.new.create_list(rand(2..4), tags: @tag_body, operation_type: 'Расход')
    other_rows = RowFactory.new.create_list(rand(2..4), tags: FFaker::Lorem.word)
    rows = rows_with_tags + other_rows

    @expenses_with_tags = rows_with_tags.inject(0) { |i, row| i + BigDecimal(row[7]) }
    @subject = described_class.new
    rows.each { |row| @subject.parse(row) }
  end

  it "counts only #{tags} expenses and returns appropriate representation" do
    expected_string =
      "#{tags} = #{printable(@expenses_with_tags)} # Заполняется суммой расходов за месяц с отметкой ##{@tag_body}"
    expect(@subject.printable_result).to eq expected_string
  end
end
