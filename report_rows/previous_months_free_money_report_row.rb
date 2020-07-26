# frozen_string_literal: true

require_relative 'base_report_row'

class PreviousMonthsFreeMoneyReportRow < BaseReportRow
  def printable_result
    @printable_result ||= "Previous months Free Money = #{printable(@previous_months_free_money)}"
  end
end
