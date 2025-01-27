module BooksHelper
  def star(book)
    sum = book.rates.map(&:star).sum
    avg = book.rates.map(&:star).count
    star = begin
      sum / avg
    rescue StandardError
      0
    end
  end
end
