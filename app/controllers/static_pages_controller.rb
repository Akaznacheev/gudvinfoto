class StaticPagesController < ApplicationController
  def home
    @partners = Partner.all.order(:id)
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
    @price_lists = PriceList.where(status: 'АКТИВЕН')
  end

  def holst_about; end
end
