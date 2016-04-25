require 'pry'

class VideosController < ApplicationController 

  get '/videos/new' do 
    @error_message = params[:error]
    if logged_in?
      @sections = current_user.sections
      erb :'/videos/new'
    else
      redirect_if_not_logged_in
    end
  end

  post '/videos' do #from new video
    if users_videos_by_link.include?(params["link"])
      @current_video = users_videos.find{|video| video.link == params["link"] }
      redirect "/videos/#{@current_video.id}?error=Video already on file"
    else
      @video = Video.new(name: params["name"], link: params["link"], year: params["year"], watched: params["watched"], embedded_link: params["embedded_link"], section_id: params["section_id"])
      @video.user_id = current_user.id
      @video.save
      redirect "/sections/#{@video.section_id}"
    end
  end

  get '/videos/:id' do 
    @error_message = params[:error]
    if logged_in?
      if @video = current_user.videos.find_by_id(params[:id]) 
        erb :'/videos/show'
      else
        redirect "/users/#{current_user.slug}/videos?error=Not your video to view"
      end
    else
      redirect_if_not_logged_in
    end
  end

  get '/videos/:id/edit' do 
    if logged_in? 
      if @video = current_user.videos.find_by_id(params[:id])
       erb :'/videos/edit'
     else
      redirect "/users/#{current_user.slug}/videos?error=Not your video to edit"
     end
    else
      redirect_if_not_logged_in
    end
  end

  post '/videos/:id/edit' do
    #raise params.inspect
    @video = Video.find_by_id(params[:id])
    @video.name = params["name"]
    @video.link = params["link"]
    @video.year = params["year"]
    @video.watched = params["watched"]
    @video.section_id = params["section_id"]
    @video.user_id = current_user.id
    if params["embedded_link"] != ""
      @video.embedded_link = params["embedded_link"]
    end
    @video.save
    redirect "/sections/#{@video.section_id}"
  end

  get '/videos/:id/delete' do
    if logged_in? 
      if @video = current_user.videos.find_by_id(params[:id])
        @video.delete
        redirect "/users/#{current_user.slug}/sections"
      else 
        redirect "/users/#{current_user.slug}/videos?error=Not your video to delete"
      end
    else
      redirect_if_not_logged_in
    end
  end

  get '/videos/:id/watched' do #are you logged in? is it your video?
    if logged_in?
        if @video = current_user.videos.find_by_id(params[:id])
          @video.watched = "yes"
          @video.save
          redirect "/sections/#{@video.section_id}"
        else
          redirect "/users/#{current_user.slug}/videos?error=Not your video to mark watched"
        end
    else
      redirect_if_not_logged_in
    end
  end

end
