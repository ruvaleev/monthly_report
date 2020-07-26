# frozen_string_literal: true

def big_decimal_value(string_value)
  string_value = string_value.to_s
  string_value.empty? ? BigDecimal(0) : BigDecimal(string_value.gsub(',', '.'))
end

def printable(big_decimal_value)
  big_decimal_value.round(2).to_f.to_s
end
