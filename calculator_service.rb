# frozen_string_literal: true

require_relative 'helpers'

class CalculatorService
  Result = Struct.new(:values)

  TAGS = {
    business: 'Business',
    investments: 'Investments',
    out_of_budget: 'Out of budget',
    next_months_expenses: "In count of next month's expenses",
    from_last_months_remains: 'From last months remains'
  }.freeze

  ACCUMULATIVE_ACCOUNTS = {
    visa_questions: 'Visa Questions Account',
    internet_fee: 'Internet Fee Account'
  }.freeze

  def initialize(operations, previous_month, monthly_budget, monthly_income)
    @operations     = operations
    @previous_month = previous_month
    @monthly_budget = monthly_budget
    @monthly_income = monthly_income
  end

  def run
    count_total_expenses
    count_tags
    count_accumulative_accounts
    count_complex_calculations
    Result.new(collect_all_variables)
  end

  private

  def count_complex_calculations # rubocop:disable Metrics/AbcSize
    @used_budget = @total_expenses + @visa_questions + @internet_fee - @out_of_budget - @from_last_months_remains -
                   @investments - @business - @next_months_expenses - @previous_month.in_count_of_current
    @monthly_free_money = @monthly_budget - @used_budget
    @free_money_total = @monthly_free_money + @previous_month.free_money
    @funds_for_investments = @monthly_income + @previous_month.funds_for_investments - @used_budget -
                             @out_of_budget - @free_money_total - @investments - @business - @next_months_expenses
  end

  def count_total_expenses
    @total_expenses = @operations.inject(0) do |sum, row|
      sum += (big_decimal_value(row.amount) if row.operation_type == 'Расход' && # rubocop:disable Lint/UselessAssignment
                            !row.source_account.include?('Visa Questions Account') &&
                            !row.source_account.include?('Internet Fee Account')) || 0
    end
  end

  def count_tags
    TAGS.each do |key, value|
      amount = @operations.inject(0) do |sum, row|
        sum += (big_decimal_value(row.amount) if row.operation_type == 'Расход' &&  # rubocop:disable Lint/UselessAssignment, Layout/ExtraSpacing
                row.tag.include?(value)) || 0
      end
      eval("@#{key} = #{amount}") # rubocop:disable Style/EvalWithLocation, Security/Eval
    end
  end

  def count_accumulative_accounts
    ACCUMULATIVE_ACCOUNTS.each do |key, value|
      amount = @operations.inject(0) do |sum, row|
        sum += (big_decimal_value(row.amount) if row.operation_type == 'Перевод' &&  # rubocop:disable Lint/UselessAssignment, Layout/ExtraSpacing
                row.destination_account.include?(value)) || 0
      end
      eval("@#{key} = #{amount}") # rubocop:disable Style/EvalWithLocation, Security/Eval
    end
  end

  def collect_all_variables
    instance_variables.each_with_object({}) do |var, result|
      value = instance_variable_get(var)
      value = printable(value) if [BigDecimal, Float, String].include?(value.class)
      result[var.to_s.gsub('@', '').to_sym] = value
    end
  end
end
