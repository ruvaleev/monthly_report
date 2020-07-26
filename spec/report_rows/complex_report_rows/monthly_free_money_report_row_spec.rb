# frozen_string_literal: true

require_relative '../../spec_helper'
require_relative '../../../report_rows/complex_report_rows/monthly_free_money_report_row'
require_relative 'complex_rows_shared_examples'

RSpec.describe MonthlyFreeMoneyReportRow do
  before do
    expenses_rows_with_incremental_tags = create_incremental_expenses_rows
    transfer_rows_to_decremental_accounts = create_decremental_transfers_rows
    expenses_rows = RowFactory.new.create_list(rand(2..4), operation_type: 'Расход', tags: FFaker::Lorem.word)
    transfer_rows =
      RowFactory.new.create_list(rand(2..4), operation_type: 'Перевод', destination_account: FFaker::Lorem.word)

    rows = expenses_rows +
           transfer_rows +
           expenses_rows_with_incremental_tags +
           transfer_rows_to_decremental_accounts

    incremental_rows_sum = rows_total_sum(expenses_rows_with_incremental_tags)
    decremental_rows_sum = rows_total_sum(expenses_rows + transfer_rows_to_decremental_accounts)

    @total_amount = incremental_rows_sum - decremental_rows_sum
    @result_string =
      ['monthly_free_money = monthly_budget - used_budget', "\n", " => #{printable(@total_amount)}"].join
    @total_result_string = "Monthly free money: #{printable(@total_amount)}"
    @subject = described_class.new
    rows.each { |row| @subject.parse(row) }
  end

  it_behaves_like 'complex_row'

  describe '#handle_non_export_data' do
    before { @monthly_budget = rand(20_000..50_000) }

    it 'increments @total_amount with @monthly_budget' do
      expect do
        @subject.handle_non_export_data(monthly_budget: @monthly_budget)
      end.to change { @subject.instance_variable_get('@total_amount') }.by(@monthly_budget)
    end
  end
end

def create_decremental_transfers_rows
  decremental_accounts.inject([]) do |rows, account|
    rows + RowFactory.new.create_list(rand(2..4), operation_type: 'Перевод', destination_account: account)
  end
end

def create_incremental_expenses_rows
  incremental_tags.inject([]) do |rows, tag|
    rows + RowFactory.new.create_list(rand(2..4), tags: tag, operation_type: 'Расход')
  end
end

def incremental_tags
  ['Business', 'Investments', 'Out of budget', "In count of next month's expenses"]
end

def decremental_accounts
  ['Visa Questions Account', 'Internet Fee Account']
end

def rows_total_sum(rows)
  rows.inject(0) { |i, row| i + BigDecimal(row[7]) }
end
