class CreateBookpages < ActiveRecord::Migration
  def change
    create_table  :bookpages do |t|
      t.integer   :pagenum,     :default => 0
      t.string    :bgcolor,     :default => 'white'
      t.integer   :template,    :default => 0
      t.timestamps null: false
    end
    add_column :bookpages, :images, :string, array: true, default: []
    add_column :bookpages, :positions, :string, array: true, default: []
  end
end
