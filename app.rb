# frozen_string_literal: true

require 'sinatra'
require_relative 'config'

get '/' do
  slim :calculator
end

post '/calculate' do
  report = ReportGenerator.new(params: params).run
  report.to_csv if params[:save_to_csv]
  report.to_html
end
