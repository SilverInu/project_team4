class BorrowRequetsController < ApplicationController
  before_action :get_books, only: [:show]
  def show
    @borrow_requet = BorrowRequet.new 
  end

  def create
    @borrow_requet = BorrowRequet.new(borrow_requet_params)
    if @borrow_requet.save
      flash[:success] = "Borrow request successfully"
      redirect_to root_path
    else
      render :show
    end
  end

  private
    def borrow_requet_params
      params.require(:borrow_requet).permit(:user_id, :book_id, :borrow_date, :return_date)
    end

    def get_books
      @book = Book.find_by_id(params[:id])
    end
end
