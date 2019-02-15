require "rails/generators/active_record/migration/migration_generator"

module Versionable
  class InstallGenerator < ActiveRecord::Generators::MigrationGenerator
    source_root File.expand_path('templates', __dir__)

    remove_argument :attributes, :name

    private

    def set_local_assigns!
      @migration_template = "migration.rb"
    end

    def name
      "CreateVersions"
    end

    def attributes
      []
    end
  end
end
