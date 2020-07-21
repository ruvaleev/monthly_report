# frozen_string_literal: true

require_relative '../../spec_helper'
require_relative '../../../report_rows/complex_report_rows/funds_for_investments_report_row'
require_relative 'complex_rows_shared_examples'
require 'byebug'

RSpec.describe FundsForInvestmentsReportRow do
  before do
    decrement_expenses = RowFactory.new.create_list(rand(2..4), operation_type: 'Расход')
    decrement_transfers =
      ['Visa Questions Account', 'Internet Fee Account'].inject([]) do |rows, account|
        rows + RowFactory.new.create_list(rand(2..4), operation_type: 'Перевод', destination_account: account)
      end
    transfer_rows =
      RowFactory.new.create_list(rand(2..4), operation_type: 'Перевод', destination_account: FFaker::Lorem.word)

    rows = transfer_rows +
           decrement_expenses +
           decrement_transfers

    @total_amount = - rows_total_sum(decrement_expenses + decrement_transfers)
    @result_string =
      ['funds_for_investments = monthly_income + previous_months_funds_for_investments',
       ' - used_budget - out_of_budget - free_money_total - investments - business',
       ' - next_months_expenses', "\n", "=> #{@total_amount}"].join
    @total_result_string = "Funds for investments: #{@total_amount}"

    @subject = described_class.new
    rows.each { |row| @subject.parse(row) }
  end

  it_behaves_like 'complex_row'

  describe '#handle_non_export_data' do
    before do
      @previous_months_free_money = rand(1000..10_000)
      @previous_months_investment_funds = rand(50_000..100_000)
      @monthly_income = rand(40_000..80_000)
      @monthly_budget = rand(40_000..60_000)
    end

    context 'when used_budget more than monthly_budget' do
      before do
        monthly_expenses = @monthly_budget + rand(5_000..10_000)
        @subject.instance_variable_set('@total_amount', -monthly_expenses)
        @subject.instance_variable_set('@out_of_budget_tags_amount', 5_000)
        income = @monthly_income + @previous_months_investment_funds
        @expected_total_amount = income - monthly_expenses - @previous_months_free_money
      end
      it 'increments @total_amount with @previous_months_free_money' do
        expect do
          @subject.handle_non_export_data(previous_months_free_money: @previous_months_free_money,
                                          previous_months_funds_for_investments: @previous_months_investment_funds,
                                          monthly_income: @monthly_income,
                                          monthly_budget: @monthly_budget)
        end.to change { @subject.instance_variable_get('@total_amount') }.to(@expected_total_amount)
      end
    end

    context 'when monthly_budget more than used_budget' do
      before do
        monthly_expenses = @monthly_budget - rand(5_000..10_000)
        @tags_expenses = 5_000
        @subject.instance_variable_set('@total_amount', -monthly_expenses)
        @subject.instance_variable_set('@out_of_budget_tags_amount', 5_000)
        income = @monthly_income + @previous_months_investment_funds
        @expected_total_amount = income - @monthly_budget - @tags_expenses - @previous_months_free_money
      end
      it 'increments @total_amount with @previous_months_free_money' do
        expect do
          @subject.handle_non_export_data(previous_months_free_money: @previous_months_free_money,
                                          previous_months_funds_for_investments: @previous_months_investment_funds,
                                          monthly_income: @monthly_income,
                                          monthly_budget: @monthly_budget)
        end.to change { @subject.instance_variable_get('@total_amount') }.to(@expected_total_amount)
      end
    end
  end
end

def rows_total_sum(rows)
  rows.inject(0) { |i, row| i + BigDecimal(row[7]) }
end
