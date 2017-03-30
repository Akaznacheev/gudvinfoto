class Admin::OrdersController < AdminController
  before_action :set_order, only: [:show, :edit, :update, :destroy]

  def index
    @orders = Order.all.order(:id).paginate(:page => params[:page], :per_page => 12)
  end

  def show
  end

  def edit
    @book = @order.book
  end

  def bookprint
    @order = Order.find(params[:order_id])
    if @order.fio.present? and @order.phone.present? and @order.email.present?
      orderdayid = Order.where("updated_at >= ?", Time.zone.now.beginning_of_day).count + 1
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
      phgallery.remove_images!
      phgallery.update_column(:images, nil)
      @order.delay.compile(@order)
      redirect_to books_path
      flash[:success] = "Ваш заказ передан в печать."
    else
      flash[:danger] = "Пожалуйста проверьте указали ли ВЫ 'Ф.И.О.', 'номер телефона' и 'email'"
      redirect_to :back
    end
  end

  def update
    if params[:delivery_id].present?
      if @order.delivery.present?
        @price = @order.price - @order.delivery.price + Delivery.find(order_params[:delivery_id].to_i).price
      else
        @price = @order.price + Delivery.find(order_params[:delivery_id].to_i).price
      end
      @order.update(:delivery_id => params[:delivery_id], :price => @price)
    end
    @order.update(status: params[:status])
    redirect_to :back
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
