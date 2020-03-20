# frozen_string_literal: true

require 'csv'
require 'json'
require 'sinatra'
require './worldometers'

# main class
class Main < Sinatra::Base
  get '/worldometers/csv' do
    scrapper = Scrappers::Worldometers.new
    summary = scrapper.summary

    body << "#{summary.first.keys.join(';')}\n"
    summary.each { |row| body << "#{row.values.join(';')}\n" }

    body
  end

  get '/worldometers/json' do
    scrapper = Scrappers::Worldometers.new
    summary = scrapper.summary

    summary.to_json
  end
end
