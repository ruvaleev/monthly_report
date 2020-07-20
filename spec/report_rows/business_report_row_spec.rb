# frozen_string_literal: true

require_relative '../spec_helper'
require_relative '../../report_rows/business_report_row'

RSpec.describe BusinessReportRow do
  before do
    business_rows = RowFactory.new.create_list(rand(2..4), tags: 'business', operation_type: 'Расход')
    other_rows = RowFactory.new.create_list(rand(2..4), tags: FFaker::Lorem.word)
    rows = business_rows + other_rows

    @business_expenses = business_rows.inject(0) { |i, row| i + BigDecimal(row[7]) }
    @subject = described_class.new
    rows.each { |row| @subject.parse(row) }
  end

  it 'counts only business expenses' do
    expect(@subject.countable_result).to eq @business_expenses
  end

  it 'returns appropriate representation' do
    expect(
      @subject.printable_result
    ).to eq "business = #{@business_expenses} # Заполняется суммой расходов за месяц с отметкой #business"
  end
end
