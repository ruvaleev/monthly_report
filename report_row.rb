# frozen_string_literal: true

class ReportRow
  attr_accessor :operation_type, :source_account, :destination_account, :tag, :amount

  def initialize(operation)
    @operation_type      = operation[1]
    @source_account      = operation[2]
    @destination_account = operation[3]
    @tag                 = operation[4]
    @amount              = operation[7]
  end
end
