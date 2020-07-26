# frozen_string_literal: true

require_relative '../helpers'

class BaseReportRow
  attr_reader :total_amount
  attr_reader :printable_result
  attr_reader :total_printable_result

  TAGS = {
    business: 'Business',
    investments: 'Investments',
    out_of_budget: 'Out of budget',
    next_months_expenses: "In count of next month's expenses"
  }.freeze

  ACCUMULATIVE_ACCOUNTS = {
    visa_questions: 'Visa Questions Account',
    internet_fee: 'Internet Fee Account'
  }.freeze

  def initialize
    @total_amount = 0
  end

  def parse(row)
    @operation_type         = row[1]
    @destination_account    = row[3]
    @tag                    = row[4]
    @amount                 = big_decimal_value(row[7])
    handle_result
  end

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

  def row_class_name
    @row_class_name ||= to_downcase(self.class.name.gsub('ReportRow', ''))
  end

  def to_downcase(camel_case_string)
    camel_case_string.gsub(/([a-z\d])([A-Z])/, '\1_\2').downcase
  end

  def tag_body
    @tag_body ||= TAGS[row_class_name.to_sym]
  end

  def account_name
    @account_name ||= ACCUMULATIVE_ACCOUNTS[row_class_name.to_sym]
  end

  def handle_result; end

  def correct_output_values_with_non_export_data; end
end
