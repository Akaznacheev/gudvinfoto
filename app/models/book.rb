# == Schema Information
#
# Table name: books
#
#  id           :integer          not null, primary key
#  price        :integer          default(0)
#  name         :string           default("My photobook")
#  fontfamily   :string           default("PT Sans")
#  fontcolor    :string           default("black")
#  fontsize     :string           default("6")
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#  user_id      :integer
#  bookprice_id :integer
#

class Book < ApplicationRecord
  belongs_to  :user
  has_many    :bookpages, -> { order(created_at: :asc) }, dependent: :destroy
  has_one     :phgallery, dependent: :destroy
  has_one     :order, dependent: :destroy
  belongs_to  :bookprice

  def setprice(bookprice)
    price = bookprice.coverprice + bookprice.twopageprice * (bookpages.count - 1) / 2
    update(bookprice_id: bookprice.id, price: price)
  end

  def book_making
    bookprice = Bookprice.find_by(default: 'ПО УМОЛЧАНИЮ')
    self.phgallery = Phgallery.create(book_id: id)
    (0..bookprice.minpagescount).lazy.each do |i|
      bookpages.create(pagenum: i, phgallery_id: phgallery.id)
    end
    price = bookprice.coverprice + bookprice.twopageprice * bookprice.minpagescount / 2
    update(user_id: current_user.id, bookprice_id: bookprice.id, price: price)
    bookpages.first.update(template: 6)
  end
end
