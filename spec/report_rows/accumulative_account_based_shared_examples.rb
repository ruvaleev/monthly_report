# frozen_string_literal: true

RSpec.shared_examples 'accumulative_account_based_row' do |account_name|
  before do
    @account_body = BaseReportRow::ACCUMULATIVE_ACCOUNTS[account_name.to_sym]
    rows_with_transfer_to_account =
      RowFactory.new.create_list(rand(2..4), destination_account: @account_body, operation_type: 'Перевод')
    other_rows = RowFactory.new.create_list(rand(2..4), destination_account: FFaker::Lorem.word)
    rows = rows_with_transfer_to_account + other_rows

    @transfers_to_account = rows_with_transfer_to_account.inject(0) { |i, row| i + BigDecimal(row[7]) }
    @subject = described_class.new
    rows.each { |row| @subject.parse(row) }
  end

  it "counts only #{account_name} transfers" do
    expect(@subject.countable_result).to eq @transfers_to_account
  end

  it 'returns appropriate representation' do
    expect(
      @subject.printable_result
    ).to eq "#{account_name} = #{@transfers_to_account} # Заплоняется суммой перевода на счет ##{@account_body}"
  end
end
