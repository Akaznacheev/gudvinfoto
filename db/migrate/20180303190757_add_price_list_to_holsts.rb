class AddPriceListToHolsts < ActiveRecord::Migration[5.1]
  def change
    add_reference :holsts, :price_list, index: true, foreign_key: true
  end
end
