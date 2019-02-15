require 'test_helper'
require 'generators/versionable/install_generator'

class Versionable::InstallGeneratorTest < ::Rails::Generators::TestCase

  tests Versionable::InstallGenerator
  destination File.expand_path("../tmp", File.dirname(__FILE__))
  setup :prepare_destination

  test "it generates versions migration" do

    run_generator

    assert_migration "db/migrate/create_versions.rb" do |content|
      assert_match("t.references :versionable, index: true, polymorphic: true", content)
      assert_match("t.references :author, index: true, polymorphic: true", content)
      assert_match("t.column :data_snapshot, :json", content)
      assert_match("t.column :data_changes, :json", content)
      assert_match("t.column :event, :integer, index: true", content)
      assert_match("t.index :created_at", content)
    end
  end
end
