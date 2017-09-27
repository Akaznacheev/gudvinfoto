module Admin
  class BookpricesController < AdminController
    before_action :set_bookprice, only: %i[show edit update destroy]

    def index
      @bookprices = Bookprice.all.order(:id)
    end

    def edit; end

    def update
      if params[:default] == 'ПО УМОЛЧАНИЮ'
        @bookprices = Bookprice.all
        @bookprices.each do |price|
          price.update(default: 'НЕТ')
        end
        @bookprice.update(default: params[:default])
      end
      @bookprice.update(status: params[:status]) if params[:status].present?
      if @bookprice.update(bookprice_params)
        redirect_to :back, notice: 'CТОИМОСТЬ' + @bookprice.format + 'ОБНОВЛЕНА.'
      else
        render :edit
      end
    end

    private

    def set_bookprice
      @bookprice = Bookprice.find(params[:id])
    end

    def bookprice_params
      params.require(:bookprice).permit(:format, :status, :default, :defaultpagescount, :coverprice,
                                        :twopageprice, :coverwidth, :coverheight, :twopagewidth, :twopageheight)
    end
  end
end
