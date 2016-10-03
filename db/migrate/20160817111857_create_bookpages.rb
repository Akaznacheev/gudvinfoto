class CreateBookpages < ActiveRecord::Migration
  def change
    create_table  :bookpages do |t|
      t.integer   :pagenum
      t.string    :positions
      t.string    :bgcolor,     :default => 'none'
      t.integer   :template,    :default => 0

      t.timestamps null: false
    end
  end
end
