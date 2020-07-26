# frozen_string_literal: true

require_relative '../spec_helper'
require_relative '../../report_rows/total_expenses_report_row'

RSpec.describe TotalExpensesReportRow do
  before do
    expenses_rows = RowFactory.new.create_list(rand(2..4), operation_type: 'Расход')
    transfer_rows = RowFactory.new.create_list(rand(2..4), operation_type: 'Перевод')
    rows = expenses_rows + transfer_rows

    @total_expenses = expenses_rows.inject(0) { |i, row| i + BigDecimal(row[7]) }
    @subject = described_class.new
    rows.each { |row| @subject.parse(row) }
  end

  it 'counts only expenses and returns appropriate representation' do
    expect(
      @subject.printable_result
    ).to eq "total_expenses = #{printable(@total_expenses)} # Заполняется общей суммой всех расходов"
  end
end
