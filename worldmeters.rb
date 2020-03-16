require 'countries/global'
require 'mechanize'

module Scrappers
  # worldmeters coronavirus scrapper
  class Worldmeters
    TABLE_URL = 'https://www.worldometers.info/coronavirus/'
    HEADERS = %i[country total_cases new_cases total_deaths new_deaths
      total_recovered active_cases serious_critical total_cases_by_1mpop].freeze

    attr_reader :agent

    def initialize
      @agent = Mechanize.new
    end

    def summary
      page = agent.get TABLE_URL
      payload = page.search('table#main_table_countries tbody tr').map do |row|
        next if row.text.include?('Total:')

        parse_table_row row
      end

      payload.reject { |item| item.nil? }
    end

    private

    def parse_table_row(row)
      record = (row.search('td').map.with_index do |item, index|
        [HEADERS[index], item.text.strip]
      end).to_h

      country = country_by_name record[:country]
      record[:latitude] = country ? country.latitude : nil
      record[:longitude] = country ? country.longitude : nil

      record
    end

    def country_by_name(country_name)
      ::ISO3166::Country.find_country_by_name country_name
    end
  end
end
