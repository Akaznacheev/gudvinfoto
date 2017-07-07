class OrdersController < ApplicationController
  before_action :set_order, only: %i(show edit update destroy)

  def index
    @orders = Order.all
  end

  def show; end

  def new
    @order = Order.new
    @book = Book.find(params[:book])
  end

  def edit; end

  def create
    @book = Book.find(params[:order][:book])
    if @book.order.present?
      @order = @book.order
      @order.update(order_params)
    else
      @order = Order.create(order_params)
    end
    if @order.save
      i = Order.where('created_at >= ?', Time.zone.now.beginning_of_day).count
      name = Time.current.strftime('%d-%m-%Y-') + '0' * (4 - i.to_s.size) + (i + 1).to_s
      book = Book.find(params[:order][:book])
      book.order = @order
      @order.update(name: name, book_id: book.id, price: book.price)
      @order.delay.compile
      redirect_to @order.payurl
      flash[:success] = 'Ваш заказ передан в печать.'
    else
      @book = Book.find(params[:order][:book])
      render :new
    end
  end

  def update
    if order_params[:delivery_id].present?
      @price = if @order.delivery.present?
                 @order.price - @order.delivery.price + Delivery.find(order_params[:delivery_id].to_i).price
               else
                 @order.price + Delivery.find(order_params[:delivery_id].to_i).price
               end
      @order.update(delivery_id: params[:delivery_id], price: @price)
    end
    if @order.update(order_params)
      bookprint
      redirect_to books_path
      flash[:success] = 'Заказ обновлен.'
    else
      render :edit
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
    params.require(:order).permit(:name, :bookscount, :fio, :phone, :zipcode, :city, :address,
                                  :email, :comment, :delivery, :price, :status, :book_id, :delivery_id)
  end
end
