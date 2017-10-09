class Book < ActiveRecord::Base
  belongs_to :user


  def self.get_book_data(user:, book_attributes:, search_term:)

    url = "https://www.googleapis.com/books/v1/volumes?q=#{search_term}&key=#{ENV['API_KEY']}"
    uri = URI(url)
    response = Net::HTTP.get(uri)
    parsed_response = JSON.parse(response)
    if parsed_response["totalItems"] >= 1
      book_data = parsed_response["items"][0]["volumeInfo"]

      new_book = user.books.new
      new_book.name = book_data["title"]
      new_book.author = book_data["authors"][0]
      new_book.cover = book_data["imageLinks"]["thumbnail"]
      new_book.isbn = book_data["industryIdentifiers"][0]["identifier"]
    
      if book_attributes["read"] == "on"
        new_book.read = true
        new_book.rating = book_attributes["rating"].to_i
        new_book.comments = book_attributes["comments"]
        new_book.date_read = Time.now
      end
    
      new_book
    else
      nil
    end
  end


end

