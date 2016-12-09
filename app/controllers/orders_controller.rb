class OrdersController < ApplicationController
  before_action :set_order, only: [:show, :edit, :update, :destroy]
  include BookmakeHelper

  def index
    @orders = Order.all
  end

  def show
  end

  def new
    @order = Order.new
  end

  def edit
    @book = @order.book
  end

  def create
  #  @book = Book.find(order_params[:book_id].to_i)
  #  if @book.order.present?
  #    @book.order.update(order_params)
  #    redirect_to edit_order_path(@book.order)
  #  else
  #    @order = Order.create(order_params)
  #    @orderdayid = Order.where("created_at >= ?", Time.zone.now.beginning_of_day).count
  #    if @orderdayid < 10
  #      @name = Time.now.strftime("%d-%m-%Y-") + "000" + @orderdayid.to_s
  #    elsif @orderdayid < 100
  #      @name = Time.now.strftime("%d-%m-%Y-") + "00" + @orderdayid.to_s
  #    elsif @orderdayid < 1000
  #      @name = Time.now.strftime("%d-%m-%Y-") + "0" + @orderdayid.to_s
  #    else
  #      @name = Time.now.strftime("%d-%m-%Y-") + @orderdayid.to_s
  #    end
  #    @order.update(:name => @name, :bookscount => 1, :fio => current_user.name, :email => current_user.email, :price => @book.price)
  #    if @order.save
  #      redirect_to edit_order_path(@order)
  #    else
  #      redirect_to :back
  #    end
  #  end
  end

  def bookprint
    @order = Order.find(params[:order_id])
    if @order.fio.present? and @order.phone.present? and @order.zipcode.present? and @order.city.present? and @order.address.present? and @order.email.present?
      @book = @order.book
      cover_create(@book.bookpages[0])
      (1..((@book.bookpages.count-1)/2)).each do |i|
        @pages          = []
        @xpx = @book.bookprice.twopagewidth
        @ypx = @book.bookprice.twopageheight
        @leftpage = @book.bookpages[2*i-1]
        if @leftpage.images.present?
          template_choose(@leftpage)
        end
        if @leftpage.template < 10
          @rightpage = @book.bookpages[2*i]
          if @rightpage.images.present?
            template_choose(@rightpage)
          end
        end
        @rzvrtnum = i
        if @leftpage.images.present?
          merge_2_page(@pages)
        end
      end
      @order.update(:status => "В печати")
      OrderMailer.send_new_order(@order).deliver_later
      redirect_to books_path
    else
      redirect_to :back
    end
  end

  def update
    if order_params[:delivery_id].present?
      if @order.delivery.present?
        @price = @order.price - @order.delivery.price + Delivery.find(order_params[:delivery_id].to_i).price
      else
        @price = @order.price + Delivery.find(order_params[:delivery_id].to_i).price
      end
      @order.update(:delivery_id => params[:delivery_id], :price => @price)
    end
    if @order.update(order_params)
      redirect_to :back
    else
      redirect_to :back
    end
  end

  def destroy
    @order.destroy
    redirect_to :back, notice: 'ЗАКАЗ' + @order.name + 'УДАЛЁН.'
  end

  private
    def set_order
      @order = Order.find(params[:id])
    end

    def order_params
      params.require(:order).permit(:name, :bookscount, :fio, :phone, :zipcode, :city, :address, :email, :comment, :delivery, :price, :status, :book_id, :delivery_id)
    end
end
