class CreatePartners < ActiveRecord::Migration[4.2]
  def change
    create_table :partners do |t|
      t.string :name
      t.string :description
      t.string :attachment
      t.timestamps null: false
    end
  end
end
