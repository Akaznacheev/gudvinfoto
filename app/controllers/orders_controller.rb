class OrdersController < ApplicationController
  before_action :set_order, only: %i[show edit update destroy]

  def index
    @orders = Order.all
  end

  def show; end

  def new
    @order = Order.new
    @book = Book.find(params[:book])
    @price_lists = PriceList.where(status: 'АКТИВЕН', kind: 'book')
    @deliveries = Delivery.all
  end

  def edit; end

  def create
    @price_lists = PriceList.where(status: 'АКТИВЕН')
    @deliveries = Delivery.all
    if params[:order][:kind] == 'holst'
      @holst = Holst.find(params[:order][:holst_id])
      @order = Order.create(order_params)
      if @order.save
        i = Order.all.where('created_at >= ?', Time.zone.now.beginning_of_day).count
        name = Time.current.strftime('%d-%m-%Y-') + '0' * (4 - i.to_s.size) + i.to_s
        @order.update(name: name, holst_id: @holst.id, price: @holst.price_list.holst_price)
        puts @order.name
        @order.delay.compile_holst
        params[:create_and_pay] ? (redirect_to @order.pay_url) : (redirect_to holst_path(@holst))
      else
        redirect_back(fallback_location: (request.referer || root_path))
      end
    else
      @book = Book.find(params[:order][:book_id])
      if @book.order.present?
        @order = @book.order
        @order.update(order_params)
      else
        @order = Order.create(order_params)
      end
      if @order.save
        i = Order.all.where('created_at >= ?', Time.zone.now.beginning_of_day).count
        name = Time.current.strftime('%d-%m-%Y-') + '0' * (4 - i.to_s.size) + i.to_s
        @book.order = @order
        @order.update(name: name, book_id: @book.id, price: @book.price)
        @order.delay.compile
        params[:create_and_pay] ? (redirect_to @order.pay_url) : (redirect_to books_path)
      else
        render :new
      end
    end
  end

  def update
    order_price_update(order_params[:delivery_id]) if order_params[:delivery_id].present?
    @order.update(order_params) ? (redirect_to books_path, notice: 'Заказ обновлен.') : (render :edit)
  end

  def order_price_update(delivery_id)
    delivery = Delivery.find(delivery_id)
    price = @order.price + delivery.price
    price -= @order.delivery.price if @order.delivery.present?
    @order.update(delivery_id: delivery.id, price: price)
  end

  def destroy
    @order.destroy
    redirect_back(fallback_location: (request.referer || root_path), notice: 'ЗАКАЗ' + @order.name + 'УДАЛЁН.')
  end

  private

  def set_order
    @order = Order.find(params[:id])
  end

  def order_params
    params.require(:order).permit(:name, :bookscount, :fio, :kind, :holst_id, :phone, :zipcode, :city, :address,
                                  :email, :comment, :price, :status, :book_id, :delivery_id)
  end
end
