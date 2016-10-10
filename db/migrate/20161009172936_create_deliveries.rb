class CreateDeliveries < ActiveRecord::Migration
  def change
    create_table :deliveries do |t|
      t.string :name
      t.integer :price

      t.timestamps null: false
    end
  end
end
