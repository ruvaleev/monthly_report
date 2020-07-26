# frozen_string_literal: true

require_relative 'base_report_row'

class MonthlyBudgetReportRow < BaseReportRow
  def printable_result
    @printable_result ||=
      "Monthly Budget = #{printable(@monthly_budget)}"
  end
end
