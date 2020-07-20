# frozen_string_literal: true

require_relative 'base_report_row'

class BusinessReportRow < BaseReportRow
  def printable_result
    "business = #{@total_amount} # Заполняется суммой расходов за месяц с отметкой #business"
  end

  private

  def handle_result
    @total_amount += @amount if @operation_type == 'Расход' && @tag == 'business'
  end
end
