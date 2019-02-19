class CreatePhotos < ActiveRecord::Migration[5.2]
  def change
    create_table :photos do |t|
      t.string :src
      t.references :post
      
      t.timestamps
    end
  end
end
