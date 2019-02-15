require_relative "version_builder"

module Versionable
  module ActsAsVersionable
    extend ActiveSupport::Concern

    class_methods do
      def acts_as_versionable(options = {})
        include ModelExtension
      end
    end

    module ModelExtension
      extend ActiveSupport::Concern

      included do
        has_many :versions, as: :versionable
      end

      def store_versions(author = nil)
        VersionBuilder.new(self, author).store
      end

    end
  end
end
