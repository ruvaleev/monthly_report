# frozen_string_literal: true

require_relative 'base_report_row'

class PreviousMonthsFundsForInvestmentsReportRow < BaseReportRow
  def printable_result
    @printable_result ||=
      "Previous months Funds For Investments = #{printable(@previous_months_funds_for_investments)}"
  end
end
