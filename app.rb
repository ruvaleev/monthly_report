# frozen_string_literal: true

require 'sinatra'
require_relative 'report_generator'

get '/' do
  slim :calculator
end

post '/calculate' do
  report_generator = ReportGenerator.new(params: params)
  @report = report_generator.run
  report_generator.to_csv if params[:save_to_csv]
  slim :report
end
