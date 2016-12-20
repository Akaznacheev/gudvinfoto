class CreateBooks < ActiveRecord::Migration
  def change
    create_table  :books do |t|
      t.integer   :price,         :default => 0
      t.string    :name,          :default => "My photobook"
      t.string    :fontfamily,    :default => "PT Sans"
      t.string    :fontcolor,     :default => "black"
      t.string    :fontsize,      :default => 6

      t.timestamps null: false
    end
    add_reference :books, :user, index: true, foreign_key: true
    add_reference :books, :bookprice, index: true, foreign_key: true
  end
end
