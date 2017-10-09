class BooksController < ApplicationController

  get "/books" do
    if logged_in?
      @to_read = current_user.books.where(read: nil)
      @read = current_user.books.where(read: true)
      erb :'books/books'
    else
      flash[:message] = "Log in to view your books."
      redirect "/login"
    end
  end

  get "/books/new" do
    if logged_in?
      erb :'books/new'
    else
      flash[:message] = "Log in to add a new book."
      session[:after_login] = "/books/new"
      redirect "/login"
    end
  end

  post "/books" do
    if params[:search_term] == ""
      flash[:message] = "Enter a title or ISBN."
      redirect "/books/new"
    elsif !logged_in?
      flash[:message] = "Log in to add a new book."
      session[:after_login] = "/books/new"
      redirect "/login"
    else
      book_data = get_book_data(params[:search_term])
      if book_data == nil
        flash[:message] = "We couldn't find your book - sorry!"
        redirect "/books/new"
      else
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
        flash[:message] = "We've added your book!"    
        redirect "/books"  
      end
    end
  end

  get "/books/:id" do
    @book = Book.find(params[:id])
    erb :'books/show'
  end

  get "/books/:id/edit" do
    @book = Book.find(params[:id])   
    if logged_in? && @book.user_id == current_user.id      
      erb :'books/edit'    
    else
      flash[:message] = "You don't have permission to do that."      
      redirect "/login"
    end
  end

  patch "/books/:id" do
    @book = Book.find(params[:id])
    if logged_in? && @book.user_id == current_user.id
      if params["read"] == "on"
        @book.read = true
        @book.rating = params["rating"].to_i
        @book.comments = params["comments"]  
        if !@book.date_read
          @book.date_read = Time.now        
        end
      else
        @book.read = nil
        @book.date_read = nil
        @book.rating = nil
        @book.comments = nil
      end
      @book.save
      flash[:message] = "We've updated your book!"
      redirect "/books/#{params[:id]}"
    else
      flash[:message] = "You don't have permission to do that."
      redirect "/login"
    end
  end

  delete "/books/:id/delete" do
    @book = Book.find(params[:id])
    if logged_in? && @book.user_id == current_user.id
      @book.delete
      flash[:message] = "We've deleted your book."      
      redirect "/books"
    else
      flash[:message] = "You don't have permission to do that."
      redirect "/login"
    end    
  end

  helpers do
    def get_book_data(search)
      url = "https://www.googleapis.com/books/v1/volumes?q=#{search}&key=#{ENV['API_KEY']}"
      uri = URI(url)
      response = Net::HTTP.get(uri)
      parsed_response = JSON.parse(response)
      if parsed_response["totalItems"] >= 1
        parsed_response["items"][0]["volumeInfo"]
      else
        nil
      end
    end
  end
end