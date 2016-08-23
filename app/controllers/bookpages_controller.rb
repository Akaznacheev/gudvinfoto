class BookpagesController < ApplicationController
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
      @bookpage.update(page_params)
      @photo = Book.find(@bookpage.book_id).phgallery.images[photo[:photo_id].to_i]
      Rails.logger.debug("PHOTO: #{@photo.inspect}")
      @images << @photo
      Rails.logger.debug("My images: #{@images.inspect}")
      @bookpage.images = @images
      Rails.logger.debug("My bookpage: #{@bookpage.images.count.inspect}")
      Rails.logger.debug("My bookpageimageurl: #{@bookpage.images[0].url.inspect}")
      Rails.logger.debug("My bookpage: #{@bookpage.inspect}")
      @bookpage.save!
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
      params.require(:bookpage).permit(:pagenum, :book_id, {images: []})
    end
    def page_params
      params.require(:bookpage_params).permit(:photo_id, :pagenum, :book_id, images: [])
    end
    def photo
      params.require(:phgallery_params).permit(:photo_id)
    end
end
