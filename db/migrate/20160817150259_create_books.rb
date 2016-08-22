class CreateBooks < ActiveRecord::Migration
  def change
    create_table :books do |t|
      t.integer :pagecount

      t.timestamps null: false
    end
  end
end
