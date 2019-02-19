require "hashdiff"

module Versionable
  module ChangeDetection
    extend ActiveSupport::Concern

    private

    def diff(before, after)
      Diff.diff(before, after)
    end
  end

  Diff = HashDiff.dup

  module Diff
    class << self

      def similar?(a, b, options = {})
        if a.is_a?(Hash) && b.is_a?(Hash)
          a["id"] === b["id"]
        else
          a === b
        end
      end

      def diff_with_similarity(a, b, options = {}, &block)
        if !b.is_a?(Hash) || options[:prefix].blank? || similar?(a, b, options)
          diff_without_similarity(a, b, options, &block)
        else
          [
            ["-", options[:prefix], a],
            ["+", options[:prefix], b]
          ]
        end
      end
      alias_method :diff_without_similarity, :diff
      alias_method :diff, :diff_with_similarity
    end
  end
end
