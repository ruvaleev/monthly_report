# frozen_string_literal: true

require_relative 'config'

class ReportGenerator
  attr_reader :report_rows

  SIMPLE_ROWS = [
    TotalExpensesReportRow,
    BusinessReportRow,
    InvestmentsReportRow,
    OutOfBudgetReportRow,
    NextMonthsExpensesReportRow,
    VisaQuestionsReportRow,
    InternetFeeReportRow
  ].freeze
  COMPLEX_ROWS = [
    UsedBudgetReportRow,
    MonthlyFreeMoneyReportRow,
    FreeMoneyTotalReportRow,
    FundsForInvestmentsReportRow
  ].freeze
  EXPORT_FILE = 'exports/CoinKeeper_export.csv'
  REPORT_DIRECTORY = 'reports'

  def initialize(params:, rows: SIMPLE_ROWS + COMPLEX_ROWS, export_file: nil, report_directory: nil)
    @year = params[:year]
    @month = params[:month]
    @monthly_budget = big_decimal_value(params[:monthly_budget])
    @monthly_income = big_decimal_value(params[:monthly_income])
    @report_rows = rows.map(&:new) unless rows.nil?
    @export_file = export_file || EXPORT_FILE
    @report_directory = report_directory || REPORT_DIRECTORY
  end

  def run
    parse_export_file
    write_previous_report_data
    self
  end

  def to_html
    "<h1># #{Date::MONTHNAMES[@month.to_i]}</h1>" \
      '<h3>Вводные данные</h3>' +
      report_rows.map { |row| "<div>#{row.printable_result}</div>" }.join +
      '</br>' \
      '<div>TOTAL:</div>' +
      report_rows.map { |row| "<div>#{row.total_printable_result}</div>" }.join
  end

  def to_csv
    file = "#{@report_directory}/#{@month.to_i}_#{@year.to_i}.csv"
    CSV.open(file, 'w') do |writer|
      report_rows.each { |row| writer << [row.total_printable_result] unless row.total_printable_result.nil? }
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
    CSV.parse(File.read(@export_file), col_sep: "\;")
  rescue CSV::MalformedCSVError
    CSV.parse(File.read(@export_file))
  end

  def can_include_in_report?(row, month, year)
    row[0]&.include?(".#{month}.#{year}")
  end

  def parse_operations
    @operations.each do |row|
      @report_rows.each { |row_service| row_service.parse(row) }
    end
  end

  def write_previous_report_data
    dig_previous_month_values
    params = {
      from_previous_months_in_count_of_current: @from_previous_months_in_count_of_current,
      previous_months_funds_for_investments: @previous_months_funds_for_investments,
      previous_months_free_money: @previous_months_free_money,
      monthly_budget: @monthly_budget,
      monthly_income: @monthly_income
    }

    @report_rows.each { |row_service| row_service.handle_non_export_data(params) }
  end

  def dig_previous_month_values
    previous_month                            = parse_previous_month_report
    @from_previous_months_in_count_of_current = big_decimal_value(previous_month['In count of next month spent'])
    @previous_months_funds_for_investments    = big_decimal_value(previous_month['Funds for investments'])
    @previous_months_free_money               = big_decimal_value(previous_month['Total free money'])
  end

  def parse_previous_month_report
    previous_month, previous_year = define_previous_month_and_year

    previous_file_name = "#{@report_directory}/#{previous_month}_#{previous_year}.csv"
    return Hash.new(0) unless File.exist?(previous_file_name)

    file = File.read(previous_file_name)
    CSV.parse(file, col_sep: "\:").to_h
  end

  def define_previous_month_and_year
    @month.to_i == 1 ? [12, @year.to_i - 1] : [@month.to_i - 1, @year]
  end
end
