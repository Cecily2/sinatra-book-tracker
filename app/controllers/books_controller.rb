class BooksController < ApplicationController

  get "/books" do
    if logged_in?
      @books = current_user.books
      erb :'books/books'
    else
      redirect "/login"
    end
  end

  get "/books/new" do
    if logged_in?
      erb :'books/new'
    else
      redirect "/login"
    end
  end

  post "/books" do
    url = "https://www.googleapis.com/books/v1/volumes?q=#{params[:search_term]}&key=#{ENV['API_KEY']}"
    uri = URI(url)
    response = Net::HTTP.get(uri)
    parsed_response = JSON.parse(response)

    book_data = parsed_response["items"][0]["volumeInfo"]

    new_book = Book.new
    
    new_book.name = book_data["title"]
    new_book.author = book_data["authors"][0]
    new_book.cover = book_data["imageLinks"]["thumbnail"]
    new_book.isbn = book_data["industryIdentifiers"][0]["identifier"]

    new_book.user_id = current_user.id

    if params["read"] == "on"
      new_book.read = true
      new_book.rating = params["rating"].to_i
      new_book.comments = params["comments"]
      new_book.date_read = Time.now
    end
    
    new_book.save

    redirect "/books"

  end

  get "/books/:id" do
    @book = Book.find(params[:id])
    erb :'books/show'
  end

  get "/books/:id/edit" do
    @book = Book.find(params[:id])
    erb :'books/edit'    
  end

  patch "/books/:id" do
    # I can check if a value has changed by
    # comparing the info in params to the info in database
  end

end