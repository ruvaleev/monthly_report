# frozen_string_literal: true

require 'sinatra'
require_relative 'report_generator'
require 'byebug'

get '/' do
  slim :calculator
end

post '/calculate' do
  @report = ReportGenerator.new(params).run.report
  slim :report
end
