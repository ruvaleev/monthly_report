# frozen_string_literal: true

class BaseReportRow
  TAGS = {
    business: 'Business',
    investments: 'Investments',
    out_of_budget: 'Out of budget',
    next_months_expenses: "In count of next month's expenses"
  }.freeze

  ACCUMULATIVE_ACCOUNTS = {
    visa_questions: 'Visa Questions Account',
    internet_fee: 'Internet Fee Account'
  }.freeze

  def initialize
    @total_amount = 0
  end

  def parse(row)
    @operation_type         = row[1]
    @destination_account    = row[3]
    @tag                    = row[4]
    @amount                 = BigDecimal(row[7])
    handle_result
  end

  def countable_result
    @total_amount
  end

  private

  def handle_result; end

  def row_class_name
    @row_class_name ||= to_downcase(self.class.name.gsub('ReportRow', ''))
  end

  def to_downcase(camel_case_string)
    camel_case_string.gsub(/([a-z\d])([A-Z])/, '\1_\2').downcase
  end

  def tag_body
    @tag_body ||= TAGS[row_class_name.to_sym]
  end

  def account_name
    @account_name ||= ACCUMULATIVE_ACCOUNTS[row_class_name.to_sym]
  end
end
