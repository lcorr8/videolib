class VideosController < ApplicationController 

  get '/videos' do
    if logged_in?
      @videos = Video.all
      erb :'/videos/videos'
    else
      redirect_if_not_logged_in
    end
  end

  get '/videos/new' do 
    if logged_in?
      @user = current_user
      @sections = Section.all.select{|section| section.user_id == @user.id}
      erb :'/videos/new'
    else
      redirect_if_not_logged_in
    end
  end

  get '/videos/:id' do 
    if logged_in?
      @video = Video.find_by_id(params[:id])
      erb :'/videos/show'
    else
      redirect_if_not_logged_in
    end
  end


  ### Post ###

  post '/videos' do 
    raise params.inspect
    @user = current_user
    @video = Video.new(name: params["name"], link: params["link"], year: params["year"])
    @video.user_id = @user.id
    @video.save
    redirect "/users/#{@user.slug}/videos"

  end

end