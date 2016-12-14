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
    @book = order.book
    cover_create(@book.bookpages[0])
    (1..(@book.bookpages.count-1)/2).each do  |i|
      @pages          = []
      @xpx = @book.bookprice.twopagewidth
      @ypx = @book.bookprice.twopageheight
      @leftpage = @book.bookpages[2*i-1]
      if @leftpage.images.present?
        template_choose(@leftpage)
      end
      if @leftpage.template < 10
        @rightpage = @book.bookpages[2*i]
        if @rightpage.images.present?
          template_choose(@rightpage)
        end
      end
      @rzvrtnum = i
      if @leftpage.images.present?
        merge_2_page(order, @pages)
      end
    end
    dir_name = "public/orders/" + order.name
    ziporder(dir_name)
    OrderMailer.send_new_order(order).deliver_later
  end
end

