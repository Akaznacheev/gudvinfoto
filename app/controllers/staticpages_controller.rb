class StaticpagesController < ApplicationController
  def home
    @partners = Partner.all
    @phgallery = Phgallery.find_by(kind: 'homepage')
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

  def inprocess; end

  def book_about
    @book = Book.new
    @phgallery = Phgallery.find_by(kind: 'homepage')
    @bookprices = Bookprice.where(status: 'АКТИВЕН')
  end

  def holst_about; end
end
