# frozen_string_literal: true

require 'csv'
require 'bigdecimal'
require_relative 'helpers'

Dir[File.join(__dir__, 'report_rows', '*.rb')].sort.each { |file| require file }
Dir[File.join(__dir__, 'report_rows', '**', '*.rb')].sort.each { |file| require file }

require_relative 'report_generator'
