require_relative "concerns/option_normalization"

module Versionable
  class VersionBuilder
    include OptionNormalization

    def initialize(record, author)
    end

    def store
    end
  end
end
