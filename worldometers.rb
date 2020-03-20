# frozen_string_literal: true

require 'mechanize'
require './helpers/countries'

module Scrappers
  # worldometers coronavirus scrapper
  class Worldometers
    TABLE_URL = 'https://www.worldometers.info/coronavirus/'
    TABLE_NAME = 'main_table_countries_today'
    HEADERS = %i[country total_cases new_cases total_deaths new_deaths
                 total_recovered active_cases serious_critical
                 total_cases_by_1mpop].freeze

    attr_reader :agent

    def initialize
      @agent = Mechanize.new

      agent.user_agent = 'Mac Safari'
    end

    def summary
      page = agent.get TABLE_URL
      payload = page.search("table##{TABLE_NAME} tbody tr").map do |row|
        next if row.text.include?('Total:')

        parse_table_row row
      end

      payload.reject(&:nil?)
    end

    private

    def parse_table_row(row)
      record = (row.search('td').map.with_index do |item, index|
        [HEADERS[index], item.text.strip]
      end).to_h

      country = ::Helpers::Countries.find_by_name record[:country]
      record[:latitude] = country&.latitude
      record[:longitude] = country&.longitude

      record
    end
  end
end
