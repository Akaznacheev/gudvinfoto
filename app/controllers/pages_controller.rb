class PagesController < ApplicationController
  before_filter :try_admin, :only => [:dashboard]

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

  def faq
  end

  def about
  end

  def shipping_and_payment
  end

  private
  def try_admin
    authenticate_user!

    if current_user.admin?
      return
    else
      redirect_to root_url # or whatever
    end
  end
end