# == Schema Information
#
# Table name: orders
#
#  id          :integer          not null, primary key
#  name        :string
#  bookscount  :integer
#  fio         :string
#  phone       :string
#  zipcode     :integer
#  city        :string
#  address     :string
#  email       :string
#  comment     :string
#  price       :integer          default(0)
#  status      :string           default("Создан")
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#  book_id     :integer
#  delivery_id :integer
#

class Order < ActiveRecord::Base
  belongs_to      :book
  belongs_to      :delivery
  
  include BookmakeHelper
  def compile(order)
    book = order.book
    @xpx = book.bookprice.twopagewidth
    @ypx = book.bookprice.twopageheight
    bookpages = book.bookpages.order(:id)
    cover = bookpages.first
    pages = bookpages.offset(1).each_slice(2).to_a
    cover_create(cover)
    pages.count.times do |i|
      merge_2_page(order.name, pages[i])
    end
    dir_name = "public/orders/" + order.name
    ziporder(dir_name)
    OrderMailer.send_new_order(order).deliver_later
    OrderMailer.send_user_about_order(order).deliver_later
  end
end

