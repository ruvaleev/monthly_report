# frozen_string_literal: true

require_relative 'base_report_row'

class MonthlyIncomeReportRow < BaseReportRow
  def printable_result
    @printable_result ||= "Monthly Income = #{printable(@monthly_income)}"
  end
end
