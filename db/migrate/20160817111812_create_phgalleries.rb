class CreatePhgalleries < ActiveRecord::Migration[4.2]
  def change
    create_table :phgalleries do |t|
      t.string :kind, default: 'book'
      t.timestamps null: false
    end
    add_column :phgalleries, :images, :string, array: true, default: []
  end
end
