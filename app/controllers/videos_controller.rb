require 'pry'

class VideosController < ApplicationController 

  get '/videos/new' do 
    if logged_in?
      @user = current_user
      @sections = Section.all.select{|section| section.user_id == @user.id}
      erb :'/videos/new'
    else
      redirect_if_not_logged_in
    end
  end

  post '/videos' do #from new video
    #raise params.inspect
    @user = current_user
    @video = Video.new(name: params["name"], link: params["link"], year: params["year"], watched: params["watched"], embedded_link: params["embedded_link"], section_id: params["section_id"])
    @video.user_id = @user.id
    @video.save
    redirect "/sections/#{@video.section_id}"
  end

  

  get '/videos/:id' do 
    if logged_in?
      @user = current_user
      @video = Video.find_by_id(params[:id])
      @section = Section.all.find_by_id(@video.section_id)
      erb :'/videos/show'
    else
      redirect_if_not_logged_in
    end
  end

  get '/videos/:id/edit' do 
    if logged_in?
      @user = current_user
      @video = Video.find_by_id(params[:id])
      @sections = Section.all.select{|section| section.user_id == @user.id}
      erb :'/videos/edit'
    else
      redirect_if_not_logged_in
    end
  end

  post '/videos/:id/edit' do
    @user = current_user
    @video = Video.find_by(params[:id])
    @video.name = params["name"]
    @video.link = params["link"]
    @video.year = params["year"]
    @video.embedded_link = params["embedded_link"]
    @video.watched = params["watched"]
    @video.section_id = params["section_id"]
    @video.save
    redirect "/sections/#{@video.section_id}"
  end





  get '/videos/:id/delete' do 
    @user = current_user
    @video = Video.find_by_id(params[:id])
    @video.delete
    redirect "/users/#{@user.slug}/sections"
  end


#################### OLD VERSION ##################
  #### is it useful to have a list of other students
  #### videos? might show repeats.
  get '/videos' do
    if logged_in?
      @videos = Video.all
      erb :'/videos/videos'
    else
      redirect_if_not_logged_in
    end
  end
  ######

end





















