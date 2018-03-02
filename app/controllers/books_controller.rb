class BooksController < ApplicationController
  before_action :set_book, only: %i[show edit update destroy]

  def index
    @books = current_or_guest_user.books.all.paginate(page: params[:page], per_page: 6)
    @book = Book.new
  end

  def show
    @book_pages = @book.book_pages
  end

  def new
    @book = Book.new
  end

  def edit
    @book_pages = @book.book_pages
    @gallery = @book.gallery
  end

  def create
    price_list = PriceList.find(params[:book][:format_id])
    price = price_list.cover_price + price_list.twopage_price * price_list.min_pages_count / 2
    @book = Book.create(user_id: current_or_guest_user.id, price_list_id: price_list.id, price: price)
    Gallery.create(book_id: @book.id)
    (0..price_list.min_pages_count).lazy.each { |i| @book.book_pages.create(page_num: i, template: [1, 2, 3, 5, 6].sample, gallery_id: @book.gallery.id) }
    @book.book_pages.first.update(template: 6)
    redirect_to edit_book_path(@book, razvorot: 0, lt: @book.book_pages[0].template, rt: @book.book_pages[1].template)
  end

  def update
    2.times { @book.book_pages.create(page_num: (@book.book_pages.last.page_num + 1), template: [1, 2, 3, 5, 6].sample, gallery_id: @book.gallery.id) } if params[:added_pages].present?
    2.times { @book.book_pages.last.destroy } if params[:destroyed_pages].present?
    @book.set_price(@book.price_list) if params[:added_pages].present? || params[:destroyed_pages].present?
    @book.update(name: cover[:name], font_size: cover[:size], font_family: cover[:family]) if params[:cover_params].present?
    if params[:price_list].present?
      price_list = PriceList.find_by(format: params[:price_list])
      @book.set_price(price_list)
      redirect_back(fallback_location: (request.referer || root_path))
    elsif params[:book].present?
      if @book.update(book_params)
        redirect_to book_path(@book, razvorot: 0, lt: @book.book_pages[0].template, rt: @book.book_pages[1].template)
      else
        render :edit
      end
    else
      redirect_to edit_book_path(@book, razvorot: (@book.book_pages.last.page_num / 2.0).round,
                                        lt: @book.book_pages[0].template, rt: @book.book_pages[1].template)
    end
  end

  def destroy
    @book.destroy
    redirect_to books_url
  end

  private

  def set_book
    @book = current_or_guest_user.try(:admin?) ? Book.find(params[:id]) : current_or_guest_user.books.find(params[:id])
  end

  def book_params
    params.require(:book).permit(:added_pages, :destroyed_pages, :gallery, :price_list, :order, :created_at)
  end

  def cover
    params.require(:cover_params).permit(:family, :size, :name)
  end
end
