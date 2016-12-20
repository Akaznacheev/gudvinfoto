class CreateBookpages < ActiveRecord::Migration
  def change
    create_table  :bookpages do |t|
      t.integer   :pagenum
      t.string    :positions
      t.string    :bgcolor,     :default => 'white'
      t.integer   :template,    :default => 0

      t.timestamps null: false
    end
    add_column :bookpages, :images, :json
    add_reference :bookpages, :book, index: true, foreign_key: true
  end
end
