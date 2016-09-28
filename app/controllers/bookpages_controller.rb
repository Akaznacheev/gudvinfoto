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
      if params[:phgallery_params].present?
        @images = []
        @photo = Book.find(@bookpage.book_id).phgallery.images[photo[:photo_id].to_i]
        @images << @photo
        @imagesfirsts = []
        @imageslasts = []
        Rails.logger.debug("My images: #{@imagesfirsts.inspect}")
        (1..(photo[:div_id].to_i - 1)).each do |i|
          if @bookpage.images[i-1].nil?
            @imagesfirsts << File.open(File.join(Rails.root, 'app','assets','images','lightgray.jpg'))
          else
            @imagesfirsts << @bookpage.images[i-1]
          end
        end
        ((photo[:div_id].to_i + 1)..14).each do |i|
          if @bookpage.images[i-1].nil?
            @imageslasts << File.open(File.join(Rails.root, 'app','assets','images','lightgray.jpg'))
          else
            @imageslasts << @bookpage.images[i-1]
          end
        end
        @images = @imagesfirsts + @images + @imageslasts
        @bookpage.update(:images => @images)
      else
        @bookpage.update(:template => params[:template])
        if @bookpage.template == 0
          @temp = @bookpage
          Rails.logger.debug("My images: #{@temp.inspect}")
          @bookpage.destroy
          Bookpage.create(:id => @temp.id, :template => @temp.template, :pagenum => @temp.pagenum, :created_at => @temp.created_at, :book_id => @temp.book_id)
        end
        if @bookpage.template == 10
          @bookpage2 = Bookpage.find(@bookpage.id + 1)
          @temp = @bookpage
          @temp2 = @bookpage2
          @bookpage.destroy
          @bookpage2.destroy
          Bookpage.create!(:id => @temp.id, :template => 0, :pagenum => @temp.pagenum, :created_at => @temp.created_at, :book_id => @temp.book_id)
          Bookpage.create!(:id => @temp2.id, :template => 0, :pagenum => @temp2.pagenum, :created_at => @temp2.created_at, :book_id => @temp2.book_id)
        end
        if @bookpage.template > 10
          @bookpage2 = Bookpage.find(@bookpage.id + 1)
          @bookpage2.update(:template => 0)
        end
        if (@bookpage.pagenum) == 0
          redirect_to edit_book_path(@bookpage.book_id, :razvorot => @bookpage.pagenum, :rt => @bookpage.template)
        else
          if (@bookpage.pagenum % 2) == 0
            redirect_to edit_book_path(@bookpage.book_id, :razvorot => (@bookpage.pagenum / 2.0).round, :lt => Bookpage.find(@bookpage.id - 1).template, :rt => @bookpage.template)
          else
            redirect_to edit_book_path(@bookpage.book_id, :razvorot => (@bookpage.pagenum / 2.0).round, :lt => @bookpage.template, :rt => Bookpage.find(@bookpage.id + 1).template)
          end
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
    def photo
      params.require(:phgallery_params).permit(:div_id, :photo_id)
    end
end
