# frozen_string_literal: true

require 'sinatra'
require_relative 'export_parser'
require_relative 'report_generator'

get '/' do
  slim :calculator
end

post '/calculate' do
  parsed_params = ExportParser.new(params[:month], params[:year]).run
  parameters = params.merge(parsed_params)
  @report = ReportGenerator.new(parameters).run.report
  slim :report
end
