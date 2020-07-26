# frozen_string_literal: true

require_relative '../spec_helper'
require_relative 'simple_rows_shared_examples'

RSpec.describe FromPreviousMonthsInCountOfCurrentReportRow do
  before do
    @amount = rand(40_000..100_000)
    @expected_result = "From previous months in count of current = #{printable(@amount)}"
    @subject = described_class.new
    @subject.handle_non_export_data(from_previous_months_in_count_of_current: @amount)
  end

  it_behaves_like 'simple_row'
end
