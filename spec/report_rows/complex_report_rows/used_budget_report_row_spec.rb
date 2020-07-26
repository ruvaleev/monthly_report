# frozen_string_literal: true

require_relative '../../spec_helper'
require_relative '../../../report_rows/complex_report_rows/used_budget_report_row'
require_relative 'complex_rows_shared_examples'

RSpec.describe UsedBudgetReportRow do
  before do
    expenses_rows_with_decremental_tags = create_decremental_expenses_rows
    transfer_rows_to_decremental_accounts = create_incremental_transfers_rows
    expenses_rows = RowFactory.new.create_list(rand(2..4), operation_type: 'Расход', tags: FFaker::Lorem.word)
    transfer_rows =
      RowFactory.new.create_list(rand(2..4), operation_type: 'Перевод', destination_account: FFaker::Lorem.word)

    rows = expenses_rows +
           transfer_rows +
           expenses_rows_with_decremental_tags +
           transfer_rows_to_decremental_accounts

    incremental_rows_sum = rows_total_sum(expenses_rows + transfer_rows_to_decremental_accounts)
    decremental_rows_sum = rows_total_sum(expenses_rows_with_decremental_tags)

    @total_amount = incremental_rows_sum - decremental_rows_sum
    @result_string = ['used_budget = ', 'total_expenses', ' + visa_questions', ' + internet_fee',
                      ' + from_previous_months_in_count_of_current', ' - out_of_budget', ' - investments',
                      ' - business', ' - from_last_months_remains', ' - in_count_of_next_months_expenses',
                      "\n", " => #{printable(@total_amount)}"].join
    @subject = described_class.new
    rows.each { |row| @subject.parse(row) }
  end

  it_behaves_like 'complex_row'

  describe '#handle_non_export_data' do
    before { @in_count_of_next_months_expenses = rand(1000..10_000) }

    it "should increment @total_amount with value of 'In count of next month spent' row" do
      expect do
        @subject.handle_non_export_data(from_previous_months_in_count_of_current: @in_count_of_next_months_expenses)
      end.to change { @subject.instance_variable_get('@total_amount') }.by(@in_count_of_next_months_expenses)
    end
  end
end

def create_incremental_transfers_rows
  incremental_accounts.inject([]) do |rows, account|
    rows + RowFactory.new.create_list(rand(2..4), operation_type: 'Перевод', destination_account: account)
  end
end

def create_decremental_expenses_rows
  decremental_tags.inject([]) do |rows, tag|
    rows + RowFactory.new.create_list(rand(2..4), tags: tag, operation_type: 'Расход')
  end
end

def decremental_tags
  ['Business', 'Investments', 'Out of budget', "In count of next month's expenses"]
end

def incremental_accounts
  ['Visa Questions Account', 'Internet Fee Account']
end

def rows_total_sum(rows)
  rows.inject(0) { |i, row| i + BigDecimal(row[7]) }
end
