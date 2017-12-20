class BookpagesController < ApplicationController
  before_action :set_bookpage, only: %i[show edit update destroy]

  def index
    @bookpages = Bookpage.all
  end

  def show; end

  def new
    @bookpage = Bookpage.new
  end

  def edit; end

  def create
    @bookpage = Bookpage.new(bookpage_params)
    if @bookpage.save
      redirect_to @bookpage, notice: 'Bookpage was successfully created.'
    else
      render :new
    end
  end

  def update
    if params[:dragimage_params]
      @bookpage.positions_update(@bookpage, move)
    elsif params[:phgallery_params] && params[:background].nil?
      @bookpage.add_image(@bookpage, photo)
    elsif params[:rotate]
      @bookpage.page_image_rotate(@bookpage, params[:image_num].to_i, params[:rotate].to_i)
      respond_to do |format|
        format.js { render inline: 'location.reload();' }
      end
    elsif params[:template]
      @bookpage.template_update(@bookpage, params[:template].to_i)
      redirect(@bookpage)
    elsif params[:background]
      parameters = params[:phgallery_params] ? [@bookpage, photo] : [@bookpage, params]
      @bookpage.background_update(*parameters)
      redirect(@bookpage) if params[:bgcolor]
    end
  end

  def redirect(page)
    if page.pagenum.zero?
      redirect_to edit_book_path(page.book_id, razvorot: page.pagenum, rt: page.template)
    elsif page.pagenum.even?
      redirect_to edit_book_path(page.book_id, razvorot: (page.pagenum / 2.0).round,
                                               lt: Bookpage.find(page.id - 1).template,
                                               rt: page.template)
    else
      redirect_to edit_book_path(page.book_id, razvorot: (page.pagenum / 2.0).round,
                                               lt: page.template,
                                               rt: Bookpage.find(page.id + 1).template)
    end
  end

  def destroy
    @bookpage.destroy
    redirect_to bookpages_url, notice: 'Bookpage was successfully destroyed.'
  end

  private

  def set_bookpage
    @bookpage = Bookpage.find(params[:id])
  end

  def bookpage_params
    params.require(:bookpage).permit(:positions, :template, :rotate, :image_num,
                                     :bgcolor, :background, :pagenum, :book_id, images: [])
  end

  def photo
    params.require(:phgallery_params).permit(:div_id, :photo_id, :background)
  end

  def move
    params.require(:dragimage_params).permit(:div_id, :positions)
  end
end
