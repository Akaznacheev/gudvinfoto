class CreateBooks < ActiveRecord::Migration
  def change
    create_table  :books do |t|
      t.string    :format, :default => "20см * 20см"
      t.integer   :price, :default => 0
      t.string    :name,  :default => "My photobook"
      t.string    :fontfamily, :default => "PT Sans"
      t.string    :fontcolor, :default => "black"
      t.string    :fontsize

      t.timestamps null: false
    end
  end
end
