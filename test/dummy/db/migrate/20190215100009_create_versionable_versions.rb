class CreateVersionableVersions < ActiveRecord::Migration[5.2]
  def change
    create_table :versionable_versions do |t|
      t.references :versionable, index: { name: "index_versionable_versions_on_versionable_type_and_id" }, polymorphic: true
      t.references :author, index: { name: "index_versionable_versions_on_author_type_and_id" }, polymorphic: true
      t.column :data_snapshot, :json
      t.column :data_changes, :json
      t.column :event, :integer, index: true
      t.timestamps
      t.index :created_at
    end
  end
end
