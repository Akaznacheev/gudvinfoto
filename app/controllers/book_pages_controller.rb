class BookPagesController < ApplicationController
  before_action :set_book_page, only: %i[show edit update destroy]

  def index
    @book_pages = BookPage.all
  end

  def show; end

  def new
    @book_page = BookPage.new
  end

  def edit; end

  def create
    @book_page = BookPage.new(book_page_params)
    if @book_page.save
      redirect_to @book_page, notice: 'BookPage was successfully created.'
    else
      render :new
    end
  end

  def update
    if params[:dragged_image_params]
      @book_page.positions_update(@book_page, move)
    elsif params[:gallery_params] && params[:background].nil?
      @book_page.add_image(@book_page, photo)
    elsif params[:rotate]
      @book_page.page_image_rotate(@book_page, params[:image_num].to_i, params[:rotate].to_i)
      respond_to do |format|
        format.js { render inline: 'location.reload();' }
      end
    elsif params[:template]
      @book_page.template_update(@book_page, params[:template].to_i)
      redirect(@book_page)
    elsif params[:background]
      parameters = params[:gallery_params] ? [@book_page, photo] : [@book_page, params]
      @book_page.background_update(*parameters)
      redirect(@book_page) if params[:background_color]
    end
  end

  def redirect(page)
    if page.page_num.zero?
      redirect_to edit_book_path(page.book_id, razvorot: page.page_num, rt: page.template)
    elsif page.page_num.even?
      redirect_to edit_book_path(page.book_id, razvorot: (page.page_num / 2.0).round,
                                               lt: BookPage.find(page.id - 1).template,
                                               rt: page.template)
    else
      redirect_to edit_book_path(page.book_id, razvorot: (page.page_num / 2.0).round,
                                               lt: page.template,
                                               rt: BookPage.find(page.id + 1).template)
    end
  end

  def destroy
    @book_page.destroy
    redirect_to book_pages_url, notice: 'BookPage was successfully destroyed.'
  end

  private

  def set_book_page
    @book_page = BookPage.find(params[:id])
  end

  def book_page_params
    params.require(:book_page).permit(:positions, :template, :rotate, :image_num,
                                      :background_color, :background, :page_num, :book_id, images: [])
  end

  def photo
    params.require(:gallery_params).permit(:div_id, :photo_id, :background)
  end

  def move
    params.require(:dragged_image_params).permit(:div_id, :positions)
  end
end
