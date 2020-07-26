# frozen_string_literal: true

require_relative 'tags_based_report_row'

class NextMonthsExpensesReportRow < TagsBasedReportRow
  def total_printable_result
    @total_printable_result ||= "In count of next month spent: #{printable(@total_amount)}"
  end
end
