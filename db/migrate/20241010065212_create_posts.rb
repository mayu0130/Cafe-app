class CreatePosts < ActiveRecord::Migration[7.2]
  def change
    create_table :posts do |t|
      t.references :user, null: false
      t.string :cafe_name, null: false
      t.text :body, null: false
      t.string :address, null: false
      t.string :cafe_link
      t.timestamps
    end
  end
end
