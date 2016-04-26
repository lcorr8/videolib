class UsersController < ApplicationController 

  get '/signup' do
    @error_message = params[:error]
    if logged_in?
      redirect "/users/#{current_user.slug}/sections"
    else
      erb :'/users/create_user'
    end
  end

  post '/signup' do 
    if usernames_taken.include?(params[:user][:username])
      redirect "/signup?error=Username is already taken"
      #erb :'/users/create_user', locals:{message:"Username is already taken"}
    else
      @user = User.create(username: params[:user][:username], password: params[:user][:password], email: params[:user][:email])
      session[:user_id] = @user.id
      redirect '/login'
    end
  end

  get '/login' do
    @error_message = params[:error]
    if logged_in? 
      redirect "/users/#{current_user.slug}/sections"
    else 
      erb :'/users/login'
    end
  end

  post '/login' do 
    @user = User.find_by(username: params[:user][:username])
    if @user && @user.authenticate(params[:user][:password])
      session[:user_id] = @user.id
      redirect "/users/#{@user.slug}/sections" #should this just render the user's sections?
    else
      redirect '/login?error=Incorrect credentials' #should this render the login page if i change how i did errors?
      #erb :'/users/login', locals:{message:"Incorrect credentials"}
    end
  end

  get '/logout' do 
    session.clear
    redirect '/'
  end

  get '/users/:slug/sections' do 
    @error_message = params[:error]
    if logged_in?
      if current_user == User.find_by_slug(params["slug"]) #is page's user the same as current user? 
        erb :'/sections/your_sections'
      else
        redirect "/users/#{current_user.slug}/sections?error=Not your section to view, see your sections below"
        #erb :'/sections/your_sections', locals:{message:"Not your section to view, see your sections below"}
      end
    else
      redirect_if_not_logged_in
    end
  end

  get '/users/:slug/videos' do 
    @error_message = params[:error]
    if logged_in?
      if current_user == User.find_by_slug(params["slug"])
        @videos = current_user.videos
        erb :'/videos/your_videos'
      else
        redirect "/users/#{current_user.slug}/videos?error=Not your videos to view, see your videos below"
        #erb :'/videos/your_videos', locals:{message:"Not your videos to view, see your videos below"}
      end
    else
      redirect_if_not_logged_in
    end
  end

get '/users/:slug/videos/not-watched' do 
    @error_message = params[:error]
    if logged_in?
      if current_user == User.find_by_slug(params["slug"])
        @videos = current_user.videos.select{|video| video.watched == "no"}
        erb :'/videos/your_videos_not_watched'
      else
        redirect "/users/#{current_user.slug}/videos/not-watched?error=Not your videos to view, see your videos below"
        #erb :'/videos/your_videos_not_watched', locals:{message:"Not your videos to view, see your videos below"}
      end
    else
      redirect_if_not_logged_in
    end
  end
 
end #end of class






