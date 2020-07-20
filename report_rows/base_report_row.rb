# frozen_string_literal: true

class BaseReportRow
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
end
