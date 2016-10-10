class CreateBookprices < ActiveRecord::Migration
  def change
    create_table :bookprices do |t|
      t.string :format
      t.integer :cover
      t.integer :page

      t.timestamps null: false
    end
  end
end
