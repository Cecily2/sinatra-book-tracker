class UsersController < ApplicationController
  get "/users/:id" do
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

end