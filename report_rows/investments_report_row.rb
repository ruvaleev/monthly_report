# frozen_string_literal: true

require_relative 'base_report_row'

class InvestmentsReportRow < BaseReportRow
  def printable_result
    "investments = #{@total_amount} # Заполняется суммой расходов за месяц с отметкой #investments"
  end

  private

  def handle_result
    @total_amount += @amount if @operation_type == 'Расход' && @tag == 'investments'
  end
end
