class BooksController < ApplicationController
  before_action :set_book, only: %i[show edit update destroy]

  def index
    @books = current_user.books.all.paginate(page: params[:page], per_page: 6)
    @book = Book.new
  end

  def show
    @bookpages = @book.bookpages.order(:id)
  end

  def new
    @book = Book.new
  end

  def edit
    @bookpages = @book.bookpages.order(:id)
    @phgallery = @book.phgallery
  end

  def create
    bookprice = Bookprice.find_by(default: 'ПО УМОЛЧАНИЮ')
    price = bookprice.coverprice + bookprice.twopageprice * bookprice.minpagescount / 2
    @book = Book.create(user_id: current_or_guest_user.id, bookprice_id: bookprice.id, price: price)
    Phgallery.create(book_id: @book.id)
    (0..bookprice.minpagescount).lazy.each { |i| @book.bookpages.create(pagenum: i, template: [1, 2, 3, 5, 6].sample, phgallery_id: @book.phgallery.id) }
    @book.bookpages.first.update(template: 6)
    redirect_to edit_book_path(@book, razvorot: 0, lt: @book.bookpages[0].template, rt: @book.bookpages[1].template)
  end

  def update
    if params[:addpages].present?
      2.times { @book.bookpages.create(pagenum: (@book.bookpages.last.pagenum + 1), phgallery_id: @book.phgallery.id) }
    end
    2.times { @book.bookpages.last.destroy } if params[:destroypages].present?
    @book.setprice(@book.bookprice) if params[:addpages].present? || params[:destroypages].present?
    if params[:cover_params].present?
      @book.update(name: cover[:name], fontsize: cover[:size], fontfamily: cover[:family])
    end
    if params[:bookprice].present?
      bookprice = Bookprice.find_by(format: params[:bookprice])
      @book.setprice(bookprice)
      redirect_back(fallback_location: (request.referer || root_path))
    elsif params[:book].present?
      if @book.update(book_params)
        redirect_to book_path(@book, razvorot: 0, lt: @book.bookpages[0].template, rt: @book.bookpages[1].template)
      else
        render :edit
      end
    else
      redirect_to edit_book_path(@book, razvorot: (@book.bookpages.last.pagenum / 2.0).round,
                                        lt: @book.bookpages[0].template, rt: @book.bookpages[1].template)
    end
  end

  def destroy
    @book.destroy
    redirect_to books_url
  end

  private

  def set_book
    @book = current_or_guest_user.books.find(params[:id])
  end

  def book_params
    params.require(:book).permit(:addpages, :destroypages, :phgallery, :bookprice, :order, :created_at)
  end

  def cover
    params.require(:cover_params).permit(:family, :size, :name)
  end
end
