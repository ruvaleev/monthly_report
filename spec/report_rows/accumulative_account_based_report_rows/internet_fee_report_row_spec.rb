# frozen_string_literal: true

require_relative '../../spec_helper'
require_relative 'accumulative_account_based_shared_examples'
require_relative '../../../report_rows/accumulative_account_based_report_rows/internet_fee_report_row'

RSpec.describe InternetFeeReportRow do
  it_behaves_like 'accumulative_account_based_row', 'internet_fee'
end
