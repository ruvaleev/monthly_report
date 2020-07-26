# frozen_string_literal: true

require_relative '../../spec_helper'
require_relative 'tags_based_shared_examples'
require_relative '../../../report_rows/tags_based_report_rows/business_report_row'

RSpec.describe BusinessReportRow do
  it_behaves_like 'tags_based_row', 'business'
end
