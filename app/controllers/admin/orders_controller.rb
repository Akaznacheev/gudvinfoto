module Admin
  class OrdersController < AdminController
    before_action :set_order, only: %i[show edit update destroy]

    def index
      @orders = Order.order(created_at: :desc).paginate(page: params[:page], per_page: 12)
    end

    def show; end

    def edit
      @book = @order.book
    end

    def bookprint
      @order = Order.find(params[:order_id])
      if @order.fio.present? && @order.phone.present? && @order.email.present?
        i = Order.all.where('created_at >= ?', Time.zone.now.beginning_of_day).count
        name = Time.current.strftime('%d-%m-%Y-') + '0' * (4 - i.to_s.size) + i.to_s
        @order.update(name: name, status: 'В печати')
        phgallery = @order.book.phgallery
        phgallery.remove_images!
        phgallery.update_column(:images, nil)
        @order.delay.compile(@order)
        redirect_to books_path
        flash[:success] = 'Ваш заказ передан в печать.'
      else
        flash[:danger] = 'Пожалуйста проверьте указали ли ВЫ Ф.И.О., номер телефона и email'
        redirect_back(fallback_location: (request.referer || root_path))
      end
    end

    def update
      if params[:delivery_id].present?
        @price = if @order.delivery.present?
                   @order.price - @order.delivery.price + Delivery.find(order_params[:delivery_id].to_i).price
                 else
                   @order.price + Delivery.find(order_params[:delivery_id].to_i).price
                 end
        @order.update(delivery_id: params[:delivery_id], price: @price)
      end
      @order.update(status: params[:status]) if params[:status].present?
      redirect_back(fallback_location: (request.referer || root_path))
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
      params.require(:order).permit(:name, :bookscount, :fio, :phone, :zipcode, :city, :address, :email,
                                    :comment, :delivery, :price, :status, :book_id, :delivery_id)
    end
  end
end
