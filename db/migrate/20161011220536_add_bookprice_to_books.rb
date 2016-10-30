class AddBookpriceToBooks < ActiveRecord::Migration
  def change
    add_reference :books, :bookprice, index: true, foreign_key: true, default: Bookprice.find_by_default("ПО УМОЛЧАНИЮ")
  end
end
