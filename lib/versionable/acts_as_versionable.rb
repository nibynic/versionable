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
        before_destroy :version_builder
      end

      def store_versions(author = nil)
        builder = version_builder
        @version_builder = nil
        builder.store(author)
      end

      def version_builder
        @version_builder ||= VersionBuilder.new(self)
      end

    end
  end
end
