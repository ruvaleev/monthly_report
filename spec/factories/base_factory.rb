# frozen_string_literal: true

require_relative '../spec_helper.rb'

class BaseFactory
  def create_list(number_of_results, *args)
    Array.new(number_of_results) { create(*args) }
  end
end
