# frozen_string_literal: true

require_relative 'base_report_row'

class AccumulativeAccountBasedReportRow < BaseReportRow
  def printable_result
    "#{row_class_name} = #{@total_amount} # Заплоняется суммой перевода на счет ##{account_name}"
  end

  private

  def handle_result
    @total_amount += @amount if @operation_type == 'Перевод' && @destination_account.include?(account_name)
  end
end
