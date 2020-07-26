# frozen_string_literal: true

require_relative '../../spec_helper'
require_relative 'tags_based_shared_examples'
require_relative '../../../report_rows/tags_based_report_rows/out_of_budget_report_row'

RSpec.describe OutOfBudgetReportRow do
  it_behaves_like 'tags_based_row', 'out_of_budget'
end
