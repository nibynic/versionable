class CreateGalleries < ActiveRecord::Migration[5.2]
  def change
    create_table :galleries do |t|
      t.string :name

      t.timestamps
    end

    add_reference :posts, :gallery
  end
end
