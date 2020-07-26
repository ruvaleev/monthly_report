# frozen_string_literal: true

require_relative '../../spec_helper'
require_relative '../../../report_rows/complex_report_rows/free_money_total_report_row'
require_relative 'complex_rows_shared_examples'

RSpec.describe FreeMoneyTotalReportRow do
  before do
    @total_amount = 0
    @result_string =
      "free_money_total = monthly_free_money + previous_months_free_money \n => #{printable(@total_amount)}"
    @total_result_string = "Total free money: #{printable(@total_amount)}"
    @subject = described_class.new
  end

  it_behaves_like 'complex_row'

  describe '#handle_non_export_data' do
    before do
      @previous_months_free_money = rand(1000..10_000)
      @monthly_budget = rand(40_000..100_000)
      @expected_sum = @previous_months_free_money + @monthly_budget
    end

    it 'increments @total_amount with @monthly_budget and @previous_months_free_money' do
      expect do
        @subject.handle_non_export_data(previous_months_free_money: @previous_months_free_money,
                                        monthly_budget: @monthly_budget)
      end.to change { @subject.instance_variable_get('@total_amount') }.by(@expected_sum)
    end
  end
end
