class Book < ActiveRecord::Base
  belongs_to  :user
  has_many    :bookpages, dependent: :destroy
  has_one     :phgallery, dependent: :destroy
  has_one     :order, dependent: :destroy
  belongs_to  :bookprice

  def setprice(bookprice)
    price = bookprice.coverprice + bookprice.twopageprice * (bookpages.count - 1) / 2
    update(bookprice_id: bookprice.id, price: price)
  end

  def pay; end
end
