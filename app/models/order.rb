# == Schema Information
#
# Table name: orders
#
#  id          :integer          not null, primary key
#  name        :string
#  bookscount  :integer          default(0)
#  fio         :string
#  phone       :string
#  zipcode     :integer          default(0)
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

class Order < ApplicationRecord
  belongs_to      :book
  belongs_to      :delivery
  validates :fio, presence: true
  validates :phone, presence: true
  validates :email, presence: true

  include BookMakeHelper
  def compile
    book = self.book
    @xpx = book.bookprice.twopagewidth
    @ypx = book.bookprice.twopageheight
    bookpages = book.bookpages.order(:id)
    cover = bookpages.first
    pages = bookpages.offset(1).each_slice(2).to_a
    GC.start
    GC.disable
    cover_create(cover)
    GC.enable
    pages.each do |two_page|
      GC.start
      GC.disable
      merge_2_page(name, two_page)
      GC.enable
    end
    dir_name = 'public/orders/' + name
    zip_order(dir_name)
    OrderMailer.send_new_order(self).deliver_later
    OrderMailer.send_user_about_order(self).deliver_later
    update(status: 'В печати')
  end

  def pay_url
    params = { shopId: '82084',
               scid: '98427',
               sum: price.to_s,
               customerNumber: phone,
               #               'custName' => URI.encode(fio),
               orderDetails: 'https://gudvinfoto.ru/orders/' + name + '.zip',
               orderNumber: name,
               custEmail: email }
    url_params = ''
    params.each { |key, value| url_params += '&' + key.to_s + '=' + value }
    'https://money.yandex.ru/eshop.xml?' + url_params
  end
end
