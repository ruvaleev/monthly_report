# frozen_string_literal: true

require_relative '../../spec_helper'
require_relative 'tags_based_shared_examples'
require_relative '../../../report_rows/tags_based_report_rows/next_months_expenses_report_row'

RSpec.describe NextMonthsExpensesReportRow do
  it_behaves_like 'tags_based_row', 'next_months_expenses'

  describe '#total_printable_result' do
    before do
      next_months_expense = rand(0..1_000).to_s
      row = RowFactory.new.create(operation_type: 'Расход',
                                  sum_in_common_currency: next_months_expense,
                                  tags: BaseReportRow::TAGS[:next_months_expenses])

      @subject = described_class.new
      @subject.parse(row)
      @total_result_string = "In count of next month spent: #{printable(BigDecimal(next_months_expense))}"
    end

    it 'returns appropriate representation for total' do
      expect(@subject.total_printable_result).to eq @total_result_string
    end
  end
end
