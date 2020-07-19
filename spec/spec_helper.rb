# frozen_string_literal: true

require 'rspec'
require 'bigdecimal'
require 'ffaker'

Dir[File.join(__dir__, 'factories', '*.rb')].sort.each { |file| require file }
