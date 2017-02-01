class DashboardController < ApplicationController
  def index

  end

  def users
    @users = User.all
  end

  def prices
    @bookprices = Bookprice.all
    @bookprice = Bookprice.new
  end

  def deliveries
    @deliveries = Delivery.all
    @delivery = Delivery.new
  end

  def orders
    @orders = Order.all
  end

  def socialicons
    @socialicons = Socialicon.all
  end

  def phgallery
    @phgallery = Phgallery.find_by_kind("homepage")
  end
end
