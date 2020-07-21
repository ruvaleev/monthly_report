# frozen_string_literal: true

require_relative '../base_report_row'

class ComplexReportRow < BaseReportRow
  def handle_non_export_data(from_previous_months_in_count_of_current: 0,
                             previous_months_funds_for_investments: 0,
                             previous_months_free_money: 0,
                             monthly_budget: 40_000,
                             monthly_income: 0)
    @from_previous_months_in_count_of_current = from_previous_months_in_count_of_current
    @previous_months_funds_for_investments    = previous_months_funds_for_investments
    @previous_months_free_money               = previous_months_free_money
    @monthly_budget                           = monthly_budget
    @monthly_income                           = monthly_income

    correct_output_values_with_non_export_data
  end

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
