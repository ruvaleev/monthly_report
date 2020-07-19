# frozen_string_literal: true

require_relative '../spec_helper'
require_relative '../../report_rows/base_report_row'

RSpec.describe BaseReportRow do
  before do
    @operation_type = FFaker::Lorem.word
    @destination_account = FFaker::Lorem.phrase
    @tag = FFaker::Lorem.word
    @amount = (100..3000).step(100).to_a.sample.to_s
    @row = RowFactory.new.create(
      operation_type: @operation_type,
      destination_account: @destination_account,
      tags: @tag,
      sum_in_common_currency: @amount
    )
    @subject = described_class.new
  end

  describe '#parse' do
    it 'saves correct operation type from row' do
      expect  do
        @subject.parse(@row)
      end.to change { @subject.instance_variable_get('@operation_type') }.from(nil).to(@operation_type)
    end

    it 'saves correct destination account from row' do
      expect  do
        @subject.parse(@row)
      end.to change { @subject.instance_variable_get('@destination_account') }.from(nil).to(@destination_account)
    end

    it 'saves correct tag from row' do
      expect { @subject.parse(@row) }.to change { @subject.instance_variable_get('@tag') }.from(nil).to(@tag)
    end

    it 'saves correct BigDecimal amount from row' do
      expect  do
        @subject.parse(@row)
      end.to change { @subject.instance_variable_get('@amount') }.from(nil).to(BigDecimal(@amount))
    end

    it 'calls handle_result method' do
      allow(@subject).to receive(:handle_result)
      @subject.parse(@row)
      expect(@subject).to have_received(:handle_result)
    end
  end
end
