# frozen_string_literal: true

require_relative '../spec_helper.rb'
require_relative 'base_factory'

class LastMonthReportFactory < BaseFactory
  def create(*args)
    custom_params = custom_params(args)
    report_keys.keys.each_with_object({}) { |key, hash| hash[report_keys[key]] = custom_params[key] || fake_value }
  end

  private

  def report_keys
    {
      monthly_free_money: 'Monthly free money',
      total_free_money: 'Total free money',
      funds_for_investments: 'Funds for investments',
      next_month_spent: 'In count of next month spent'
    }
  end

  def fake_value
    [['', '', '-'].sample, rand(100..10_000), '.', rand(0...100)].join
  end

  def custom_params(args)
    return {} if args.nil? || !args.first.is_a?(Hash)

    args.first.select { |key, _value| report_keys.keys.include?(key) }
  end
end
