# frozen_string_literal: true

require_relative '../../spec_helper'
require_relative '../../../report_rows/complex_report_rows/complex_report_row'

RSpec.describe ComplexReportRow do
  describe '#handle_non_export_data' do
    before { @subject = described_class.new }

    it 'returns nil' do
      expect(@subject.handle_non_export_data).to be nil
    end
  end
end
