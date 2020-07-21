# frozen_string_literal: true

require_relative '../../spec_helper'
require_relative '../../../report_rows/complex_report_rows/free_money_total_report_row'
require_relative 'complex_rows_shared_examples'

RSpec.describe FreeMoneyTotalReportRow do
  before do
    @total_amount = 0
    @result_string = "free_money_total = monthly_free_money + previous_months_free_money \n => #{@total_amount}"
    @total_result_string = "Total free money: #{@total_amount}"
    @subject = described_class.new
  end

  it_behaves_like 'complex_row'

  describe '#handle_non_export_data' do
    before { @previous_months_free_money = rand(1000..10_000) }

    it 'increments @total_amount with @previous_months_free_money' do
      expect do
        @subject.handle_non_export_data(previous_months_free_money: @previous_months_free_money)
      end.to change { @subject.instance_variable_get('@total_amount') }.by(@previous_months_free_money)
    end
  end
end
