# frozen_string_literal: true

require 'csv'
require 'bigdecimal'

class ReportGenerator
  Result = Struct.new(:report)

  def initialize(params)
    params.each { |key, value| instance_variable_set("@#{key}", BigDecimal(value)) }
    @month = params[:month].to_i
    @year = params[:year].to_i
  end

  def run
    dig_previous_month_values
    calculate_values
    normalize_variables
    generate_csv_report
    Result.new(collect_all_variables)
  end

  private

  def dig_previous_month_values
    previous_month                            = parse_previous_month_report
    @from_previous_months_in_count_of_current = BigDecimal(previous_month['In count of next month spent'])
    @previous_months_funds_for_investments    = BigDecimal(previous_month['Funds for investments'])
    @previous_months_free_money               = BigDecimal(previous_month['Total free money'])
  end

  def calculate_values
    @used_budget = calculate_used_budget
    @monthly_free_money = @monthly_budget - @used_budget
    @free_money_total = @monthly_free_money + @previous_months_free_money
    @funds_for_investments = calculate_funds_for_investments
  end

  def calculate_used_budget
    budget_expenses = @total_expenses + @visa_questions + @internet_fee + @from_previous_months_in_count_of_current
    non_budget_expenses = @out_of_budget - @investments - @business - @in_count_of_next_months_expenses
    budget_expenses - non_budget_expenses
  end

  def calculate_funds_for_investments
    income = @monthly_income + @previous_months_funds_for_investments
    expenses = @used_budget - @free_money_total - @investments - @business
    income - expenses
  end

  def normalize_variables
    instance_variables.each { |var| instance_variable_set(var, instance_variable_get(var).to_f) }
  end

  def generate_csv_report
    file = "reports/#{@month.to_i}_#{@year.to_i}.csv"
    @month = Date::MONTHNAMES[@month]
    CSV.open(file, 'w') do |writer|
      writer << ['Monthly free money', @monthly_free_money]
      writer << ['Total free money', @free_money_total]
      writer << ['Funds for investments', @funds_for_investments]
      writer << ['In count of next month spent', @in_count_of_next_months_expenses]
    end
  end

  def parse_previous_month_report
    if @month == 1
      previous_month = 12
      previous_year = @year - 1
    else
      previous_month = @month - 1
      previous_year = @year
    end

    previous_file_name = "reports/#{previous_month}_#{previous_year}.csv"
    file = File.read(previous_file_name)
    CSV.parse(file, col_sep: "\;").to_h
  end

  def collect_all_variables
    instance_variables.each_with_object({}) do |var, result|
      result[var.to_s.gsub('@', '').to_sym] = instance_variable_get(var)
    end
  end
end
