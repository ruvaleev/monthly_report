# frozen_string_literal: true

require_relative 'helpers'

class PreviousMonthReportParser
  Result = Struct.new(:in_count_of_current, :funds_for_investments, :free_money)

  def initialize(month, year)
    @month = month
    @year  = year
  end

  def run
    previous_month = parse_previous_month_report
    Result.new(
      big_decimal_value(previous_month['In count of next month spent']),
      big_decimal_value(previous_month['Funds for investments']),
      big_decimal_value(previous_month['Total free money'])
    )
  end

  private

  def parse_previous_month_report
    previous_month, previous_year = define_previous_month_and_year

    previous_file_name = "reports/#{previous_month}_#{previous_year}.csv"
    return Hash.new(0) unless File.exist?(previous_file_name)

    file = File.read(previous_file_name)
    CSV.parse(file, col_sep: "\:").to_h
  end

  def define_previous_month_and_year
    @month.to_i == 1 ? [12, @year.to_i - 1] : [@month.to_i - 1, @year]
  end
end
