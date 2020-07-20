# frozen_string_literal: true

require_relative 'base_report_row'

class TagsBasedReportRow < BaseReportRow
  def printable_result
    "#{tags_name} = #{@total_amount} # Заполняется суммой расходов за месяц с отметкой ##{tags_name}"
  end

  private

  def handle_result
    @total_amount += @amount if @operation_type == 'Расход' && @tag == tags_name
  end

  def tags_name
    @tags_name ||= to_downcase(self.class.name.gsub('ReportRow', ''))
  end

  def to_downcase(camel_case_string)
    camel_case_string.gsub(/::/, '/')
                     .gsub(/([A-Z]+)([A-Z][a-z])/, '\1_\2')
                     .gsub(/([a-z\d])([A-Z])/, '\1_\2')
                     .tr('-', '_')
                     .downcase
  end
end
