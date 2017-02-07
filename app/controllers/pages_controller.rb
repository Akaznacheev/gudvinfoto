class PagesController < ApplicationController

  def home
    @book = Book.new
    @socialicons = Socialicon.all
    @phgallery = Phgallery.find_by_kind("homepage")
    respond_to do |format|
      format.json
      format.html
      format.html.phone
      format.html.tablet
    end
  end

  def about_us
  end

  def how_to_order
  end

  def faq
  end

  def delivery
  end

  def advantages
  end

  def trust_us
  end

end