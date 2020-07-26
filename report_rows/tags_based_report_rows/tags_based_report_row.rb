# frozen_string_literal: true

require_relative '../base_report_row'

class TagsBasedReportRow < BaseReportRow
  def printable_result
    @printable_result =
      "#{row_class_name} = #{printable(@total_amount)} # Заполняется суммой расходов за месяц с отметкой ##{tag_body}"
  end

  private

  def handle_result
    @total_amount += @amount if @operation_type == 'Расход' && @tag.include?(tag_body)
  end
end
