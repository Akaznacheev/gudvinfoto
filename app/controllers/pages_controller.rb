class PagesController < ApplicationController
  before_filter :custom_method, :only => [:dashboard]

  def home
    @book = Book.new
  end

  def faq
  end

  def about
  end

  def shipping_and_payment
  end

  def dashboard
    @phgallery = Phgallery.find_by_kind("homepage")
    @socialicons = Socialicon.all
    @bookprices = Bookprice.all
    @users = User.all
  end

  private
  def custom_method
    authenticate_user!

    if current_user.admin?
      return
    else
      redirect_to root_url # or whatever
    end
  end
end