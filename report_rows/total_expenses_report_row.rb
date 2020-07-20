# frozen_string_literal: true

require_relative 'base_report_row'

class TotalExpensesReportRow < BaseReportRow
  def printable_result
    "total_expenses = #{@total_amount} # Заполняется общей суммой всех расходов"
  end

  private

  def handle_result
    @total_amount += @amount if @operation_type == 'Расход'
  end
end
