class Admin::BooksController < AdminController
  before_action :get_books, except: [:index, :new, :create]

  before_action :logged_in_user

  before_action :admin_user
  
  def new
    @book = Book.new
    @book.build_publisher
    @book.build_author
  end
  
  def index
    @books = Book.includes(:author).search(params)
      .order_name
      .paginate(page: params[:page], per_page: 10)
      respond_to do |format|
        format.html
        format.xls { send_data @books.to_xls(col_sep: "\t") } 
      end
  end

  def destroy
    if @book.borrow_requets.exists?
      flash[:warning] = "Book delete failed"
    else 
      @book&.destroy
      flash[:success] = "Delete successfully"
    end
    render :index
  end

  def show
  end

  def update
    if @book.update(book_params)
      flash[:success] = "Book updated"
      render :index
    else
      flash[:warning] = "Book updatedd failed"
      render :edit
    end
  end

  def create
    @book = Book.new(book_params)
    if @book.save
      flash[:success] = "Book create successfully"
      redirect_to new_admin_book_path
    else
      flash[:warning] = "Book create failed"
      render :new
    end
  end

  private

    def book_params
      params.require(:book).permit(:name, :amount, :price, :status, :author_id, :publisher_id, 
        publisher_attributes:[:name], author_attributes:[:name])
    end
    
    def get_books
      @book = Book.find_by_id(params[:id])
      return if @book
      flash[:warning] = "That book could not be found"
      render :index  
    end

end
