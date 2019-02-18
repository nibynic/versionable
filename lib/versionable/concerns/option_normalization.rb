module Versionable
  module OptionNormalization
    extend ActiveSupport::Concern

    private

    def options
      @options ||= normalize_options(record.class.versionable_options)
    end

    def normalize_options(options = {})
      options[:root] = false
      force_except_option(options)
      options
    end

    def force_except_option(options = {})
      options[:except] = to_array(options[:except]) + [:created_at, :updated_at]

      included = to_hash(options[:include])
      if included.any?
        options[:include] = included
        options[:include].each do |key, value|
          force_except_option(value)
        end
      end
    end

    def to_array(value)
      value.is_a?(Array) ? value : [value].compact
    end

    def to_hash(value)
      case value
      when Hash then value
      when Array then value.map { |key| [key, {}] }.to_h
      else [value].compact.map { |key| [key, {}] }.to_h
      end
    end
  end
end
