# frozen_string_literal: true

require_relative '../spec_helper'
require_relative '../../report_rows/tags_based_report_row'

RSpec.describe TagsBasedReportRow do
  before do
    @subject = described_class.new
    @total_amount = BigDecimal(rand(1000..10_000).to_s)
    @subject.instance_variable_set('@total_amount', @total_amount)

    first_class_name_word = FFaker::Name.first_name
    last_class_name_word = FFaker::Name.first_name
    allow(described_class).to receive(:name).and_return("#{first_class_name_word}#{last_class_name_word}")
    @tags_name = "#{first_class_name_word.downcase}_#{last_class_name_word.downcase}"
  end

  describe '#printable_result' do
    it 'returns appropriate result depends on class name and amount' do
      expect(
        @subject.printable_result
      ).to eq "#{@tags_name} = #{@total_amount} # Заполняется суммой расходов за месяц с отметкой ##{@tags_name}"
    end
  end
end
