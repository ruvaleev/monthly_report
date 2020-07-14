# frozen_string_literal: true

require 'csv'
require 'bigdecimal'

class ExportParser
  REPORT_FIELDS = %i[
    total_expenses
    business
    investments
    out_of_budget
    next_months_expenses
    visa_questions
    internet_fee
  ].freeze

  TAGS = {
    'Business' => 'business',
    'Investments' => 'investments',
    'Out of budget' => 'out_of_budget',
    "In count of next month's expenses" => 'next_months_expenses'
  }.freeze

  ACCUMULATIVE_ACCOUNTS = {
    'Visa Questions Account' => 'visa_questions',
    'Internet Fee Account' => 'internet_fee'
  }.freeze

  EXPORT_FILE = 'exports/CoinKeeper_export.csv'
  MONTHLY_BUDGET = 40_000
  EXPENSE_TRAIT = 'Расход'
  TRANSFER_TRAIT = 'Перевод'

  Result = Struct.new(*REPORT_FIELDS)

  def initialize(month, year)
    file                  = CSV.parse(File.read(EXPORT_FILE))
    @operations           = file.select { |row| can_include_in_report?(row, month, year) }
    @total_expenses       = 0
    @business             = 0
    @investments          = 0
    @out_of_budget        = 0
    @next_months_expenses = 0
    @visa_questions       = 0
    @internet_fee         = 0
  end

  def run
    @operations.each { |row| count_transfer_or_expense(row) }
    Result.new(*generate_result)
  end

  private

  def can_include_in_report?(row, month, year)
    row[0]&.include?(".#{month}.#{year}")
  end

  def count_transfer_or_expense(row)
    if row[1].include?(EXPENSE_TRAIT)
      count_expense(row[4], BigDecimal(row[7].gsub(',', '.')))
    elsif row[1].include?(TRANSFER_TRAIT)
      count_accumulative_accounts(row[3], BigDecimal(row[7].gsub(',', '.')))
    end
  end

  def count_expense(row_tags, amount)
    @total_expenses += amount
    count_expense_by_tags(row_tags, amount)
  end

  def count_expense_by_tags(row_tags, amount)
    return if row_tags.empty?

    TAGS.each do |tag, variable|
      return increment_varaiable(variable, amount) if row_tags.include?(tag)
    end
  end

  def count_accumulative_accounts(transfer_account, amount)
    ACCUMULATIVE_ACCOUNTS.each do |account, variable|
      return increment_varaiable(variable, amount) if transfer_account.include?(account)
    end
  end

  def increment_varaiable(variable, amount)
    value = instance_variable_get("@#{variable}")
    instance_variable_set("@#{variable}", value + amount)
  end

  def generate_result
    REPORT_FIELDS.map { |field| instance_variable_get("@#{field}") }
  end
end
