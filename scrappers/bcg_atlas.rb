# frozen_string_literal: true

require 'rest-client'
require 'json'
require 'nokogiri'

require './helpers/parsers'

module Scrappers
  # scrapper to bcg atlas
  class BcgAtlas < Base
    DATA_URL = 'http://www.bcgatlas.org/data.php'
    CURRENT_SITUATION_TEXT = 'Current BCG vaccination?'
    ENDS_AT_TEXT = 'Year BCG stopped?'
    COVERAGE_TEXT = 'BCG coverage (%)'
    INCOME_GROUP_TEXT = 'Income group (World Bank)'
    STARTS_AT_TEXT = 'Which year was vaccination introduced?'

    def initialize
      raw_data = RestClient.get DATA_URL
      @parsed_data = JSON.parse(raw_data)
      @parsers = ::Helpers::Parsers
    end

    def countries
      @parsed_data.map do |segment|
        name = segment['name'].strip
        info = Nokogiri::HTML.parse(segment['info'])
        geopoint = resolve_geopoint name

        {
          id: segment['id'],
          name: name,
          current_situation: parse(info, CURRENT_SITUATION_TEXT, :bool),
          ends_at: parse(info, ENDS_AT_TEXT),
          coverage: parse(info, COVERAGE_TEXT, :float),
          income_group: parse(info, INCOME_GROUP_TEXT),
          starts_at: parse(info, STARTS_AT_TEXT),
          latitude: geopoint ? geopoint.latitude : nil,
          longitude: geopoint ? geopoint.longitude : nil,
          country_code_alpha_2: geopoint ? geopoint.alpha2 : nil,
          country_code_alpha_3: geopoint ? geopoint.alpha3 : nil
        }
      end
    end

    private

    # :reek:UtilityFunction
    def resolve_geopoint(country_name)
      ::Helpers::Countries.find_by_name country_name
    end

    def parse(html, key, type = :string)
      response = html.at("tr:contains('#{key}')/td[3]")

      return @parsers.parse_type(type) unless response

      @parsers.parse_type(type, response.text)
    end
  end
end
