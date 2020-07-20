# frozen_string_literal: true

require_relative '../spec_helper'
require_relative '../../report_rows/accumulative_account_based_report_row'

RSpec.describe AccumulativeAccountBasedReportRow do
  before do
    @subject = described_class.new
    @total_amount = BigDecimal(rand(1000..10_000).to_s)
    @account_name = BaseReportRow::ACCUMULATIVE_ACCOUNTS.keys.sample
    @account_body = BaseReportRow::ACCUMULATIVE_ACCOUNTS[@account_name]

    @subject.instance_variable_set('@total_amount', @total_amount)
    allow(described_class).to receive(:name).and_return(@account_name.to_s.split('_').map(&:capitalize).join)
  end

  describe '#printable_result' do
    it 'returns appropriate result depends on tags_body and amount' do
      expect(
        @subject.printable_result
      ).to eq "#{@account_name} = #{@total_amount} # Заплоняется суммой перевода на счет ##{@account_body}"
    end
  end
end
