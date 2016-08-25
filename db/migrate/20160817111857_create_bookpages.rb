class CreateBookpages < ActiveRecord::Migration
  def change
    create_table :bookpages do |t|
      t.integer :pagenum
      t.integer  :template, :default => 0

      t.timestamps null: false
    end
  end
end
