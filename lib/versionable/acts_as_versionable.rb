require_relative "version_builder"

module Versionable
  module ActsAsVersionable
    extend ActiveSupport::Concern

    class_methods do
      def acts_as_versionable(options = {})
        include ModelExtension
        @versionable_options = options
      end

      attr_reader :versionable_options
    end

    module ModelExtension
      extend ActiveSupport::Concern

      included do
        has_many :versions, as: :versionable, class_name: "Versionable::Version"
      end

      def store_versions(author = nil)
        VersionBuilder.new(self, author).store
      end

    end
  end
end
