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