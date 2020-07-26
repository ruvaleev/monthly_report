# frozen_string_literal: true

require_relative '../base_report_row'

class ComplexReportRow < BaseReportRow
  private

  def correct_output_values_with_non_export_data; end

  def handle_result
    decrement_value || increment_value
  end

  def decrement_value
    @total_amount -= @amount if can_decrement?
  end

  def increment_value
    @total_amount += @amount if can_increment?
  end
end
