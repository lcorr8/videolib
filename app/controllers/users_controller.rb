class UsersController < ApplicationController 

  get '/signup' do
    @error_message = params[:error]
    if logged_in?
      @user = current_user
      redirect "/users/#{@user.slug}/sections"
    else
      erb :'/users/create_user'
    end
  end

  post '/signup' do 
    if usernames_taken.include?(params[:user][:username])
      redirect "/signup?error=Username is already taken"
    else
      @user = User.create(username: params[:user][:username], password: params[:user][:password], email: params[:user][:email])
      session[:user_id] = @user.id
      redirect '/login'
    end
  end

  get '/login' do
    @error_message = params[:error]
    if logged_in?
      @user = current_user
      redirect "/users/#{@user.slug}/sections"
    else 
      erb :'/users/login'
    end
  end

  post '/login' do 
    @user = User.find_by(username: params[:user][:username])
    #verify username and password
    if @user && @user.authenticate(params[:user][:password])
      session[:user_id] = @user.id
      redirect "/users/#{@user.slug}/sections"
    else
      redirect '/login?error=Incorrect credentials'
    end
  end

  get '/logout' do 
    session.clear
    redirect '/'
  end

  get '/users/:slug/sections' do 
    #raise params.inspect
    @error_message = params[:error]
    if logged_in?
    @users_page = User.find_by_slug(params["slug"])
    @user = current_user
      if @users_page == @user #page's user the same as current user
        erb :'/sections/your_sections'
      else
        redirect '/sections'
      end
    else
      redirect_if_not_logged_in
    end
  end



#user video's list is kind of useless if not organized.
  get '/users/:slug/videos' do 
    #raise params.inspect
    @error_message = params[:error]
    if logged_in?
    @users_page = User.find_by_slug(params["slug"])
    @user = current_user
      if @users_page == @user
        @videos = Video.all.select{|video| video.user_id == @user.id}
        erb :'/videos/your_videos'
      else
        redirect '/videos'
      end
    else
      redirect_if_not_logged_in
    end
  end
###################################################

get '/users/:slug/videos/not-watched' do 
    #raise params.inspect
    @error_message = params[:error]
    if logged_in?
    @users_page = User.find_by_slug(params["slug"])
    @user = current_user
      if @users_page == @user
        @videos = Video.all.select{|video| video.user_id == @user.id && video.watched == "no"}
        erb :'/videos/your_videos_not_watched'
      else
        redirect '/videos'
      end
    else
      redirect_if_not_logged_in
    end
  end
 
end #end of class






