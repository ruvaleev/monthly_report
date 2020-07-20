# frozen_string_literal: true

require_relative 'complex_report_row'

class UsedBudgetReportRow < ComplexReportRow
  def printable_result # rubocop:disable Metrics/MethodLength
    ['used_budget = ',
     ' total_expenses',
     ' + visa_questions',
     ' + internet_fee',
     ' + from_previous_months_in_count_of_current',
     ' - out_of_budget',
     ' - investments',
     ' - business',
     ' - from_last_months_remains',
     ' - in_count_of_next_months_expenses',
     "\n",
     " => #{@total_amount}"].join
  end

  private

  def correct_output_values_with_non_export_data
    @total_amount += @from_previous_months_in_count_of_current
  end

  def can_decrement?
    @operation_type == 'Расход' &&
      (@tag.include?(BaseReportRow::TAGS[:out_of_budget]) ||
      @tag.include?(BaseReportRow::TAGS[:investments]) ||
      @tag.include?(BaseReportRow::TAGS[:business]) ||
      @tag.include?(BaseReportRow::TAGS[:next_months_expenses]))
  end

  def can_increment?
    @operation_type == 'Расход' ||
      @operation_type == 'Перевод' &&
        (
          @destination_account.include?(BaseReportRow::ACCUMULATIVE_ACCOUNTS[:visa_questions]) ||
          @destination_account.include?(BaseReportRow::ACCUMULATIVE_ACCOUNTS[:internet_fee])
        )
  end
end
