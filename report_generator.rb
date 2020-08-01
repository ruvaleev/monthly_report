# frozen_string_literal: true

require 'csv'
require 'bigdecimal'
require_relative 'previous_month_report_parser'
require_relative 'calculator_service'
require_relative 'report_row'

class ReportGenerator
  def initialize(params:)
    @year = params[:year]
    @month = params[:month]
    @monthly_budget = big_decimal_value(params[:monthly_budget])
    @monthly_income = big_decimal_value(params[:monthly_income])
  end

  def run
    previous_month = PreviousMonthReportParser.new(@month, @year).run
    parse_export_file
    @values = CalculatorService.new(@operations, previous_month, @monthly_budget, @monthly_income).run.values
    @values.merge(month: Date::MONTHNAMES[@month.to_i])
  end

  def to_csv
    file = "reports/#{@month.to_i}_#{@year.to_i}.csv"
    CSV.open(file, 'w') do |writer|
      [
        ["In count of next month spent: #{@values[:next_months_expenses]}"],
        ["Monthly free money: #{@values[:monthly_free_money]}"],
        ["Total free money: #{@values[:free_money_total]}"],
        ["Funds for investments: #{@values[:funds_for_investments]}"]
      ].each { |row| writer << row }
    end
  end

  private

  def parse_export_file
    select_operations_from_export_file
    parse_operations
  end

  def select_operations_from_export_file
    file             = read_export_file
    normalized_month = @month.to_s.length < 2 ? @month.to_s.prepend('0') : @month
    @operations      = file.select { |row| can_include_in_report?(row, normalized_month, @year) }
  end

  def read_export_file
    CSV.parse(File.read('exports/CoinKeeper_export.csv'), col_sep: "\;")
  rescue CSV::MalformedCSVError
    CSV.parse(File.read('exports/CoinKeeper_export.csv'))
  end

  def can_include_in_report?(row, month, year)
    row[0]&.include?(".#{month}.#{year}")
  end

  def parse_operations
    @operations.map! { |operation| ReportRow.new(operation) }
  end
end
