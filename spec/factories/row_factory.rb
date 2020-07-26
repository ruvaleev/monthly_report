# frozen_string_literal: true

require_relative '../spec_helper.rb'
require_relative 'base_factory'

class RowFactory < BaseFactory
  def create(*args)
    define_attributes(args).values
  end

  private

  def attributes
    %i[date operation_type source_account destination_account tags sum_in_local_currency
       local_currency sum_in_common_currency common_currency repeat_parameter note]
  end

  def fake_date
    [rand(10..30), '06', '2020'].join('.')
  end

  def fake_operation_type
    %w[Расход Перевод].sample
  end

  def fake_source_account
    ['THB card', 'Thai wallet', 'RUB Tkb card'].sample
  end

  def fake_destination_account
    ['Some Expenses', 'Visa Questions Account', 'Internet Fee Account'].sample
  end

  def fake_tags
    ['', 'Business', 'Investments', 'Out of budget', "In count of next month's expenses"].sample
  end

  def fake_sum_in_local_currency
    (100..3000).step(100).to_a.sample.to_s
  end

  def fake_local_currency
    %w[THB RUB USD].sample
  end

  def fake_sum_in_common_currency
    (100..3000).step(100).to_a.sample.to_s
  end

  def fake_common_currency
    'THB'
  end

  def fake_repeat_parameter
    'Нет'
  end

  def fake_note
    ['Some', 'Optional', 'Note', ''].sample
  end
end
