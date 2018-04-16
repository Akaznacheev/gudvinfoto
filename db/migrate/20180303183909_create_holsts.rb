class CreateHolsts < ActiveRecord::Migration[5.1]
  def change
    create_table :holsts do |t|
      t.string :format
      t.integer :price,  default: 0
      t.string :image
      t.string :positions,  default: '0'

      t.timestamps
    end
  end
end
