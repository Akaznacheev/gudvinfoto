# == Schema Information
#
# Table name: books
#
#  id            :integer          not null, primary key
#  price         :integer          default(0)
#  name          :string           default("My photobook")
#  font_family   :string           default("PT Sans")
#  font_color    :string           default("black")
#  font_size     :string           default("6")
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#  user_id       :integer
#  price_list_id :integer
#

class Book < ApplicationRecord
  belongs_to :user
  has_many :book_pages, -> { order(created_at: :asc) }, dependent: :destroy
  has_one :gallery, dependent: :destroy
  has_one :order, dependent: :destroy
  belongs_to :price_list

  def set_price(price_list)
    price = price_list.cover_price + price_list.twopage_price * (book_pages.count - 1) / 2
    update(price_list_id: price_list.id, price: price)
  end

  def book_making
    price_list = PriceList.find_by(default: 'ПО УМОЛЧАНИЮ')
    gallery = Gallery.create(book_id: id)
    (0..price_list.min_pages_count).lazy.each do |i|
      book_pages.create(page_num: i, gallery_id: gallery.id)
    end
    price = price_list.cover_price + price_list.twopage_price * price_list.min_pages_count / 2
    update(user_id: current_user.id, price_list_id: price_list.id, price: price)
    book_pages.first.update(template: 6)
  end
end
