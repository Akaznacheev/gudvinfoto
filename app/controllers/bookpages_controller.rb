class BookpagesController < ApplicationController
  before_action :authenticate_user!
  before_action :set_bookpage, only: [:show, :edit, :update, :destroy]

  def index
    @bookpages = Bookpage.all
  end

  def show
  end

  def new
    @bookpage = Bookpage.new
  end

  def edit
  end

  def create
    @bookpage = Bookpage.new(bookpage_params)

      if @bookpage.save
        redirect_to @bookpage, notice: 'Bookpage was successfully created.'
      else
        render :new
      end
  end

  def update
      @images = []
      if params[:page_params].present? && params[:phgallery_params].present?
        @bookpage.update(page_params)
        @photo = Book.find(@bookpage.book_id).phgallery.images[photo[:photo_id].to_i]
        @images << @photo
        @bookpage.images = @images
        @bookpage.save!
      else
        @bookpage.update(:template => params[:template])
        if @bookpage.template == 0
          @temp = @bookpage
          Rails.logger.debug("My images: #{@temp.inspect}")
          @bookpage.destroy
          Bookpage.create!(:id => @temp.id, :pagenum => @temp.pagenum, :created_at => @temp.created_at, :book_id => @temp.book_id)
        end
        if (@bookpage.pagenum % 2) == 0
          redirect_to edit_book_path(@bookpage.book_id, :razvorot => (@bookpage.pagenum / 2.0).round, :lt => Bookpage.find(@bookpage.id - 1).template, :rt => @bookpage.template)
        else
          redirect_to edit_book_path(@bookpage.book_id, :razvorot => (@bookpage.pagenum / 2.0).round, :lt => @bookpage.template, :rt => Bookpage.find(@bookpage.id + 1).template)
        end
      end
  end


  def destroy
    @bookpage.destroy
    redirect_to bookpages_url, notice: 'Bookpage was successfully destroyed.'
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_bookpage
      @bookpage = Bookpage.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def bookpage_params
      params.require(:bookpage).permit(:template, :pagenum, :book_id, {images: []})
    end
    def page_params
      params.require(:page_params).permit(:id, :photo_id, :pagenum, :book_id, images: [])
    end
    def photo
      params.require(:phgallery_params).permit(:photo_id)
    end
end
