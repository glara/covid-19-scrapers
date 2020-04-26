# frozen_string_literal: true

require 'csv'
require 'json'
require 'sinatra'
require './scrapers/worldometers'
require './scrapers/bcg_atlas'

# main class
class Main < Sinatra::Base
  get '/worldometers/csv' do
    scraper = Scrapers::Worldometers.new
    summary = scraper.summary

    body << "#{summary.first.keys.join(';')}\n"
    summary.each { |row| body << "#{row.values.join(';')}\n" }

    body
  end

  get '/worldometers/json' do
    scraper = Scrapers::Worldometers.new
    summary = scraper.summary

    summary.to_json
  end

  get '/bcg_atlas/csv' do
    scraper = Scrapers::BcgAtlas.new
    countries = scraper.countries

    body << "#{countries.first.keys.join(';')}\n"
    countries.each { |row| body << "#{row.values.join(';')}\n" }

    body
  end

  get '/bcg_atlas/json' do
    scraper = Scrapers::BcgAtlas.new
    countries = scraper.countries

    countries.to_json
  end
end
