class CreateSocialicons < ActiveRecord::Migration[4.2]
  def change
    create_table :socialicons do |t|
      t.string :name
      t.string :iconlink
      t.timestamps null: false
    end
  end
end
