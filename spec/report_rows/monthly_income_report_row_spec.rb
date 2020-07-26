# frozen_string_literal: true

require_relative '../spec_helper'
require_relative 'simple_rows_shared_examples'

RSpec.describe MonthlyIncomeReportRow do
  before do
    @amount = rand(40_000..100_000)
    @expected_result = "Monthly Income = #{printable(@amount)}"
    @subject = described_class.new
    @subject.handle_non_export_data(monthly_income: @amount)
  end

  it_behaves_like 'simple_row'
end
