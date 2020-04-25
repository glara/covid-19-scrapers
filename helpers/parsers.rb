# frozen_string_literal: true

module Helpers
  # parser helper
  class Parsers
    def self.parse_type(type, value = nil)
      return '' if type == :string && !value

      method("parse_type_#{type}").call(value)
    end

    def self.parse_type_bool(value)
      return true if %w[yes 1].include?(value.to_s.downcase)

      false
    end

    def self.parse_type_string(value)
      value.to_s
    end

    def self.parse_type_float(value)
      return unless value

      value.match(/\d+/).to_s.to_f
    end
  end
end
