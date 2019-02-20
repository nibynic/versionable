class CreateBanners < ActiveRecord::Migration[5.2]
  def change
    create_table :banners do |t|
      t.text :text
      t.references :category

      t.timestamps
    end
  end
end
