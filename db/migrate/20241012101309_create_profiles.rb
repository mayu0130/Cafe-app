class CreateProfiles < ActiveRecord::Migration[7.2]
  def change
    create_table :profiles do |t|
      t.references :user, null: false, foreign_key: true
      t.string :nickname, null: false
      t.string :mbti
      t.date :birthday
      t.string :address
      t.text :introduction, null: false
      t.string :x_link
      t.string :instagram_link
      t.timestamps
    end
  end
end
