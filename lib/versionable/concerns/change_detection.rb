require "hashdiff"

module Versionable
  module ChangeDetection
    extend ActiveSupport::Concern

    private

    def diff(before, after)
      HashDiff.diff(before, after)
    end
  end
end
