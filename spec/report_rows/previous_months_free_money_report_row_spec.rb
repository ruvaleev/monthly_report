# frozen_string_literal: true

require_relative '../spec_helper'
require_relative 'simple_rows_shared_examples'

RSpec.describe PreviousMonthsFreeMoneyReportRow do
  before do
    @amount = rand(40_000..100_000)
    @expected_result = "Previous months Free Money = #{printable(@amount)}"
    @subject = described_class.new
    @subject.handle_non_export_data(previous_months_free_money: @amount)
  end

  it_behaves_like 'simple_row'
end
