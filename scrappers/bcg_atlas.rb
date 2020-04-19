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

    def initialize
      raw_data = RestClient.get DATA_URL
      @parsed_data = JSON.parse(raw_data)
      @parsers = ::Helpers::Parsers
    end

    def countries
      @parsed_data.map do |segment|
        name = segment['name'].strip
        info = Nokogiri::HTML.parse(segment['info'])

        {
          name: name,
          current_situation: parse(info, CURRENT_SITUATION_TEXT, :bool),
          ends_at: parse(info, ENDS_AT_TEXT),
          coverage: parse(info, COVERAGE_TEXT, :float),
          income_group: parse(info, INCOME_GROUP_TEXT)
        }
      end
    end

    private

    def parse(html, key, type = :string)
      response = html.at("tr:contains('#{key}')/td[3]")

      return @parsers.parse_type(type) unless response

      @parsers.parse_type(type, response.text)
    end
  end
end
