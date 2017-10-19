class AddBookpriceToBooks < ActiveRecord::Migration[4.2]
  def change
    add_reference :books, :bookprice, index: true, foreign_key: true
  end
end
