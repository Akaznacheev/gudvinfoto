class OrdersController < ApplicationController
  before_action :set_order, only: [:show, :edit, :update, :destroy]

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
    if @order.fio.present? and @order.phone.present? and @order.email.present?
      orderdayid = Order.where("created_at >= ?", Time.zone.now.beginning_of_day).count + 1
      if orderdayid < 10
        @name = Time.now.strftime("%d-%m-%Y-") + "000" + orderdayid.to_s
      elsif orderdayid < 100
        @name = Time.now.strftime("%d-%m-%Y-") + "00" + orderdayid.to_s
      elsif orderdayid < 1000
        @name = Time.now.strftime("%d-%m-%Y-") + "0" + orderdayid.to_s
      else
        @name = Time.now.strftime("%d-%m-%Y-") + orderdayid.to_s
      end
      @order.update(:name => @name, :status => "В печати")
      phgallery = @order.book.phgallery
      (1..phgallery.images.count).each do |index|
        remain_images = phgallery.images # copy the array
        deleted_image = remain_images.delete_at(index) # delete the target image
        deleted_image.try(:remove!) # delete image from S3
        if remain_images.count < 1
          tmp = phgallery
          phgallery.destroy
          phgallery = Phgallery.new(:id=> tmp.id, :book_id => tmp.book_id, :images => []) # re-assign back
          phgallery.save
        else
          phgallery.update(:images => remain_images) # re-assign back
        end
      end
      @order.delay.compile(@order)
      redirect_to books_path
      flash[:success] = "Ваш заказ передан в печать."
    else
      flash[:danger] = "Пожалуйста проверьте указали ли ВЫ 'Ф.И.О.', 'номер телефона' и 'email'"
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
