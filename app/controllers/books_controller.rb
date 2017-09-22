class BooksController < ApplicationController

  get "/books" do
    if logged_in?
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
    url = "https://openlibrary.org/api/books?bibkeys=ISBN:#{params[:isbn]}&format=json&jscmd=data"
    uri = URI(url)
    response = Net::HTTP.get(uri)
    parsed_response = JSON.parse(response)

    new_book = Book.new(isbn: params[:isbn])
    new_book.name = parsed_response["ISBN:#{params[:isbn]}"]["title"]
    new_book.author = parsed_response["ISBN:#{params[:isbn]}"]["authors"][0]["name"]
    new_book.cover = parsed_response["ISBN:#{params[:isbn]}"]["cover"]["large"]
    
    new_book.user_id = current_user.id

    if params["read"] == "on"
      new_book.read = true
      new_book.rating = params["rating"].to_i
      new_book.comments = params["comments"]
      new_book.date_read = Time.now
    end

  end

  get "/books/:id" do
  end

  get "/books/:id/edit" do
  end

  patch "/books/:id" do
    # I can check if a value has changed by
    # comparing the info in params to the info in database
  end

end