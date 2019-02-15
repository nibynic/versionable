class CreateVersions < ActiveRecord::Migration[5.2]
  def change
    create_table :versions do |t|
      t.references :versionable, index: true, polymorphic: true
      t.references :author, index: true, polymorphic: true
      t.column :data_snapshot, :json
      t.column :data_changes, :json
      t.column :event, :integer, index: true
      t.timestamps
      t.index :created_at
    end
  end
end
