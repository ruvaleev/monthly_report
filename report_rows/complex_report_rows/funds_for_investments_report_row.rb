# frozen_string_literal: true

require_relative 'complex_report_row'

class FundsForInvestmentsReportRow < ComplexReportRow
  def initialize
    super
    @out_of_budget_tags_amount = 0
  end

  def printable_result
    [
      'funds_for_investments = monthly_income + previous_months_funds_for_investments',
      ' - used_budget - out_of_budget - free_money_total - investments - business',
      ' - next_months_expenses', "\n", "=> #{@total_amount}"
    ].join
  end

  private

  def correct_output_values_with_non_export_data
    @total_amount = used_budget - @out_of_budget_tags_amount - @previous_months_free_money
    @total_amount += @monthly_income + @previous_months_funds_for_investments
  end

  def handle_result
    decrement_value if can_decrement?
    increment_tags_values if can_increment_tag_values?
  end

  def increment_tags_values
    @out_of_budget_tags_amount += @amount
  end

  def can_increment_tag_values?
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

  def used_budget
    -[@total_amount.abs - @out_of_budget_tags_amount, @monthly_budget].max
  end
end
