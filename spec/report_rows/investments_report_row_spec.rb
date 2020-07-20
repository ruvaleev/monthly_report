# frozen_string_literal: true

require_relative '../spec_helper'
require_relative 'tags_based_shared_examples'
require_relative '../../report_rows/investments_report_row'

RSpec.describe InvestmentsReportRow do
  it_behaves_like 'tags_based_row', 'investments'
end
