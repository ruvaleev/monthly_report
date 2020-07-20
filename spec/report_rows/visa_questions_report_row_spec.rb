# frozen_string_literal: true

require_relative '../spec_helper'
require_relative 'accumulative_account_based_shared_examples'
require_relative '../../report_rows/visa_questions_report_row'

RSpec.describe VisaQuestionsReportRow do
  it_behaves_like 'accumulative_account_based_row', 'visa_questions'
end
