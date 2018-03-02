module Admin
  class PriceListsController < AdminController
    before_action :set_price_list, only: %i[show edit update destroy]

    def index
      @price_lists = PriceList.all
    end

    def edit; end

    def update
      if @price_list.update(price_list_params)
        PriceList.where.not(id: @price_list.id).each { |price| price.update(default: 'НЕТ') }
        redirect_back(fallback_location: (request.referer || root_path),
                      notice: @price_list.format + ' ФОРМАТ ОБНОВЛЕН')
      else
        render :edit
      end
    end

    private

    def set_price_list
      @price_list = PriceList.find(params[:id])
    end

    def price_list_params
      params.require(:price_list).permit(:format, :status, :default, :cover_price, :twopage_price, :cover_width,
                                         :cover_height, :twopage_width, :twopage_height, :min_pages_count, :max_pages_count)
    end
  end
end
