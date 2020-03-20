# frozen_string_literal: true

require 'countries/global'

module Helpers
  # clean countries
  class Countries
    def self.find_by_name(name)
      country = finder.find_country_by_name name

      return country if country

      find_in_dict name
    end

    def self.find_in_dict(name)
      finder.find_country_by_name dict[name.gsub(/\s+/, '').upcase]
    end

    def self.finder
      ::ISO3166::Country
    end

    def self.dict
      YAML.load_file('config/countries_dict.yml')
    end
  end
end
