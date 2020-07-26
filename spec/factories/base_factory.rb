# frozen_string_literal: true

require_relative '../spec_helper.rb'

class BaseFactory
  def create_list(number_of_results, *args)
    Array.new(number_of_results) { create(*args) }
  end

  private

  def define_attributes(args)
    @attributes =
      attributes.each_with_object({}) { |key, hash| hash[key] = send("fake_#{key}") }.merge(custom_params(args))
  end

  def custom_params(args)
    return {} if args.nil? || !args.first.is_a?(Hash)

    args.first.select { |key, _value| attributes.include?(key) }
  end
end
