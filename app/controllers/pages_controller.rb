class PagesController < ApplicationController
  before_action :authenticate_user!
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
    if current_user.admin?
    else
      redirect_to root_path, :alert => "У Вас нет доступа."
    end
  end
end