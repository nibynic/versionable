module Versionable
  module OptionNormalization
    extend ActiveSupport::Concern

    private

    def normalize_options(options = {})
      options[:root] = false
      force_except_option(options)
      options
    end

    def get_included_paths(options = {})
      paths = []
      to_hash(options[:include]).each do |key, value|
        paths += [key.to_s] + get_included_paths(value).map do |nested_key|
          [key, nested_key].join(".")
        end
      end
      paths
    end

    def force_except_option(options = {})
      options[:except] = to_array(options[:except]) + [:created_at, :updated_at]

      included = to_hash(options[:include])
      if included.any?
        options[:include] = included
        options[:except] += included.map do |key, value|
          :"#{key}_id" if key.to_s.singularize == key.to_s
        end.compact
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
