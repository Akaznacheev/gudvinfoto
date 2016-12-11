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
  end

  def bookprint
    @order = Order.find(params[:order_id])
    if @order.fio.present? and @order.phone.present? and @order.zipcode.present? and @order.city.present? and @order.address.present? and @order.email.present?
      @order.delay.compile(@order)
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
