class AddColumnsToPriceLists < ActiveRecord::Migration[5.1]
  def change
    add_column :price_lists, :kind, :string, default: 'book'
    add_column :price_lists, :holst_price, :integer, default: 0
  end
end
