# frozen_string_literal: true

require_relative 'base_report_row'

class FromPreviousMonthsInCountOfCurrentReportRow < BaseReportRow
  def printable_result
    @printable_result ||=
      "From previous months in count of current = #{printable(@from_previous_months_in_count_of_current)}"
  end
end
