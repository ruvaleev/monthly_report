# frozen_string_literal: true

require_relative 'monthly_free_money_report_row'

class FreeMoneyTotalReportRow < MonthlyFreeMoneyReportRow
  def printable_result
    @printable_result ||=
      "free_money_total = monthly_free_money + previous_months_free_money \n => #{printable(@total_amount)}"
  end

  def total_printable_result
    @total_printable_result ||= "Total free money: #{printable(@total_amount)}"
  end

  private

  def correct_output_values_with_non_export_data
    @total_amount += @monthly_budget + @previous_months_free_money
  end
end
