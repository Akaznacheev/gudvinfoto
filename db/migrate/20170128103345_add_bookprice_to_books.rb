class AddBookpriceToBooks < ActiveRecord::Migration
  def change
    add_reference :books, :bookprice, index: true, foreign_key: true
  end
end
