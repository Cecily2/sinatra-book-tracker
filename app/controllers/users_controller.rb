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
    user = User.new(params)
    binding.pry
    redirect "/books"
  end

  get "/login" do
    if logged_in?
      redirect "/books"
    else
      erb :'users/login'
    end
  end

end