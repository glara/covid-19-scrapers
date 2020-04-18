# frozen_string_literal: true

require 'csv'
require 'json'
require 'sinatra'
require './scrappers/worldometers'
require './scrappers/bcg_atlas'

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

  get '/bcg_atlas/csv' do
    scrapper = Scrappers::BcgAtlas.new
    countries = scrapper.countries

    body << "#{countries.first.keys.join(';')}\n"
    countries.each { |row| body << "#{row.values.join(';')}\n" }

    body
  end

  get '/bcg_atlas/json' do
    scrapper = Scrappers::BcgAtlas.new
    countries = scrapper.countries

    countries.to_json
  end
end
