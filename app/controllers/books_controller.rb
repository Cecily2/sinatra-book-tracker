class BooksController < ApplicationController

  get "/books" do
    if logged_in?
      @to_read = current_user.to_read
      @read = current_user.read
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
    if !logged_in?
      flash[:message] = "Log in to add a new book."
      session[:after_login] = "/books/new"
      redirect "/login"
    elsif params[:search_term] == ""
        flash[:message] = "Enter a title or ISBN."
        redirect "/books/new"  
    else
      book = Book.get_book_data(user: current_user, book_attributes: params[:book], search_term: params[:search_term])
      if book && book.save   
        flash[:message] = "We've added your book!"    
        redirect "/books"  
      else 
        flash[:message] = "We couldn't find your book - sorry!"
        redirect "/books/new"
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

end