# frozen_string_literal: true

require_relative '../spec_helper'
require_relative '../../report_rows/tags_based_report_row'

RSpec.describe TagsBasedReportRow do
  before do
    @subject = described_class.new
    @total_amount = BigDecimal(rand(1000..10_000).to_s)
    @tags_name = BaseReportRow::TAGS.keys.sample
    @tag_body = BaseReportRow::TAGS[@tags_name]

    @subject.instance_variable_set('@total_amount', @total_amount)
    allow(described_class).to receive(:name).and_return(@tags_name.to_s.split('_').map(&:capitalize).join)
  end

  describe '#printable_result' do
    it 'returns appropriate result depends on tags_body and amount' do
      expect(
        @subject.printable_result
      ).to eq "#{@tags_name} = #{@total_amount} # Заполняется суммой расходов за месяц с отметкой ##{@tag_body}"
    end
  end
end
