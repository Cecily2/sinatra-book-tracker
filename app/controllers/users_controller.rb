class UsersController < ApplicationController
  get "/users" do
    erb :'users/users'
  end

  get "/users/:id" do
    @user = User.find(params[:id])
    @to_read = @user.books.where(read: nil).find_each
    @read = @user.books.where(read: true).find_each
    erb :'users/show'
  end

  get "/signup" do
    if logged_in?
      redirect "/books"
    else
      erb :'users/new'
    end
  end

  post "/signup" do    
    if user = User.new(params)
      user.save
      session[:user_id] = user.id
      redirect "/books"
    else
      redirect "/signup"
    end
  end

  get "/login" do
    if logged_in?
      redirect "/books"
    else
      erb :'users/login'
    end
  end

  post "/login" do
    user = User.find_by(:username => params[:username])
    if user && user.authenticate(params[:password])
      session[:user_id] = user.id
      redirect "/books"
    else
      redirect "/login"
    end
  end

  get "/logout" do
    session.clear
    redirect "/login"
  end


end