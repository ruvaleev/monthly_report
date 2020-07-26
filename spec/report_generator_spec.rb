# frozen_string_literal: true

require_relative 'spec_helper'
require_relative '../report_generator'

RSpec.describe ReportGenerator do
  before(rows: :total_expenses) { @rows = [TotalExpensesReportRow] }
  before(rows: :random) { @rows = described_class::SIMPLE_ROWS.sample(rand(5)) }
  before do
    @month = 6
    @year = 2020
    @monthly_income = rand(40_000..100_000)
    @monthly_budget = rand(40_000..60_000)
    @params = { year: @year, month: @month, monthly_income: @monthly_income, monthly_budget: @monthly_budget }
    @subject = described_class.new(params: @params, rows: @rows, export_file: 'spec/support/test_export.csv')
  end

  describe '#run', rows: :total_expenses do
    it 'parses export file and populates future report rows by correct values' do
      # 55 - is a sum of expenses in spec/support/test_export.csv' file
      expect { @subject.run }.to change { @subject.report_rows.first.total_amount }.from(0).to(55)
    end

    it 'returns self' do
      expect(@subject.run).to be_kind_of(described_class)
    end
  end

  describe '#to_html', rows: :random do
    before do
      @subject.run
      @html_result = @subject.to_html
    end

    it 'returns string' do
      expect(@html_result).to be_kind_of(String)
    end

    it 'wraps report rows to html tags' do
      expect(@html_result[0..3]).to eq('<h1>')
      expect(@html_result[-6..-1]).to eq('</div>')
    end
  end

  describe '#to_csv', rows: :random do
    before do
      @total_printable_results = Array.new(rand(1..5)) { FFaker::Lorem.sentence }
      @report_rows = @total_printable_results.each_with_object([]) do |value, rows|
        report_row = BaseReportRow.new
        report_row.instance_variable_set('@total_printable_result', value)
        rows << report_row
      end
      report_directory = 'spec/support'
      @subject = described_class.new(params: @params, rows: nil, report_directory: report_directory)
      @subject.instance_variable_set('@report_rows', @report_rows)
      @subject.run
      @subject.to_csv
      @report = File.read("#{report_directory}/#{@month}_#{@year}.csv")
    end

    it 'writes total printable results to CSV file rows' do
      @total_printable_results.each { |expected_row| expect(@report.include?(expected_row)).to be_truthy }
    end
  end
end
