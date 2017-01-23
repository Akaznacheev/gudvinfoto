class CreatePhgalleries < ActiveRecord::Migration
  def change
    create_table :phgalleries do |t|
      t.string :kind,     :default => 'book'

      t.timestamps null: false
    end
    add_column :phgalleries, :images, :json
    add_reference :phgalleries, :book, index: true, foreign_key: true
  end
end
