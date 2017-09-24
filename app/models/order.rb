class Order < ActiveRecord::Base
  belongs_to      :book
  belongs_to      :delivery
  validates :fio, presence: true
  validates :phone, presence: true
  validates :email, presence: true

  include BookmakeHelper
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
    pages.each do |razvorot|
      GC.start
      GC.disable
      merge_2_page(name, razvorot)
      GC.enable
    end
    dir_name = 'public/orders/' + name
    ziporder(dir_name)
    OrderMailer.send_new_order(self).deliver_later
    OrderMailer.send_user_about_order(self).deliver_later
  end

  def payurl
    params = { 'shopId' => '82084',
               'scid' => '98427',
               'sum' => price.to_s,
               'customerNumber' => phone,
               #               'custName' => URI.encode(fio),
               'orderDetails' => 'https://gudvinfoto.ru/orders/' + name + '.zip',
               'orderNumber' => name,
               'custEmail' => email }
    urlparams = ''
    params.each { |p| urlparams += '&' + p[0] + '=' + p[1] }
    payurl = 'https://money.yandex.ru/eshop.xml?' + urlparams
  end
end
