class StaticPagesController < ApplicationController
  def home
    @partners = Partner.all.order(:id)
    @price_list = PriceList.where(status: 'АКТИВЕН', kind: 'holst').first
    @holst = Holst.new
    @gallery = Gallery.find_by(kind: 'homepage')
    respond_to do |format|
      format.json
      format.html
      format.html.phone
    end
  end

  def about_us; end

  def how_to_order; end

  def faq; end

  def delivery; end

  def advantages; end

  def trust_us
    @partners = Partner.all
  end

  def events; end

  def in_process; end

  def choose_book_format
    @book = Book.new
    @gallery = Gallery.find_by(kind: 'homepage')
    @book_price_list = PriceList.where(status: 'АКТИВЕН', kind: 'book')
  end

  def choose_holst_format; end
end
