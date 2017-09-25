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
    user = User.new(params)
    if user.save
      session[:user_id] = user.id
      redirect "/books"
    else
      flash[:message] = ""
      user.errors.each do |key, array|
        flash[:message] += "#{key.to_s.capitalize} "
        flash[:message] += "#{array}. "
      end
      flash[:message] += "Try again?"
      redirect "/signup"
    end
  end

  get "/login" do
    if logged_in?
      session.clear
    end
    erb :'users/login'   
  end

  post "/login" do
    user = User.find_by(:username => params[:username])
    if user && user.authenticate(params[:password])
      session[:user_id] = user.id
      if session[:after_login]
        redirect session[:after_login]
      else
        redirect "/books"
      end
    else
      if user
        flash[:message] = "Incorrect password! Try again?"
      else
        flash[:message] = "No such user! Try again?"
      end
      redirect "/login"
    end
  end

  get "/logout" do
    session.clear
    redirect "/login"
  end


end