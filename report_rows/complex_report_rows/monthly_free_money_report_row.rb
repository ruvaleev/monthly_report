# frozen_string_literal: true

require_relative 'complex_report_row'

class MonthlyFreeMoneyReportRow < ComplexReportRow
  def printable_result
    ['monthly_free_money = monthly_budget - used_budget', "\n", " => #{@total_amount}"].join
  end

  private

  def correct_output_values_with_non_export_data
    @total_amount += @monthly_budget
  end

  def handle_result
    increment_value || decrement_value
  end

  def can_increment?
    @operation_type == 'Расход' &&
      (@tag.include?(BaseReportRow::TAGS[:out_of_budget]) ||
      @tag.include?(BaseReportRow::TAGS[:investments]) ||
      @tag.include?(BaseReportRow::TAGS[:business]) ||
      @tag.include?(BaseReportRow::TAGS[:next_months_expenses]))
  end

  def can_decrement?
    @operation_type == 'Расход' ||
      @operation_type == 'Перевод' &&
        (
          @destination_account.include?(BaseReportRow::ACCUMULATIVE_ACCOUNTS[:visa_questions]) ||
          @destination_account.include?(BaseReportRow::ACCUMULATIVE_ACCOUNTS[:internet_fee])
        )
  end
end
