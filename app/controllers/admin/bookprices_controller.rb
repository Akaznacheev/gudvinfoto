module Admin
  class BookpricesController < AdminController
    before_action :set_bookprice, only: %i[show edit update destroy]

    def index
      @bookprices = Bookprice.all
    end

    def edit; end

    def update
      if @bookprice.update(bookprice_params)
        Bookprice.where.not(id: @bookprice.id).each { |price| price.update(default: 'НЕТ') }
        redirect_back(fallback_location: (request.referer || root_path),
                      notice: 'ФОРМАТ ' + @bookprice.format + ' ОБНОВЛЕН')
      else
        render :edit
      end
    end

    private

    def set_bookprice
      @bookprice = Bookprice.find(params[:id])
    end

    def bookprice_params
      params.require(:bookprice).permit(:format, :status, :default, :coverprice, :twopageprice, :coverwidth,
                                        :coverheight, :twopagewidth, :twopageheight, :minpagescount, :maxpagescount)
    end
  end
end
