class SectionsController < ApplicationController 

  get '/sections/new' do
    @error_message = params[:error] 
    if logged_in?
      erb :'/sections/new'
    else
      redirect_if_not_logged_in
    end
  end

  get '/sections/:id' do 
    #raise params.inspect
    @error_message = params[:error]
    if logged_in?
      @section = Section.find_by_id(params[:id])
      @user = current_user
      @videos = @section.videos
      if @section.user_id == @user.id
        erb :'/sections/show'
      else
        redirect "/users/#{@user.slug}/sections?error=Not your section to view, see your sections below"
      end
    else
      redirect_if_not_logged_in
    end
  end

  get '/sections/:id/edit' do 
    if logged_in?
      @section = Section.find_by_id(params[:id])
      @user = current_user
      if @user.id == @section.user_id
        erb :'/sections/edit'
      else
        redirect "/users/#{@user.slug}/sections?error=Not your section to edit"
      end
    else
      redirect_if_not_logged_in
    end
  end

  get '/sections/:id/delete' do 
    if logged_in?
      @user = current_user
      @section = Section.find_by_id(params[:id])
      if @user.id == @section.user_id 
        if @section.videos.count == 0
          @section.delete        
          redirect "/users/#{@user.slug}/sections"
        else
          redirect "/users/#{@user.slug}/sections?error=Unable to delete section because it still contains videos"
        end
      else
        redirect "/users/#{@user.slug}/sections?error=Not your section to delete"
      end
    else
      redirect_if_not_logged_in
    end
  end

  post '/sections' do 
    #raise params.inspect
    @user = current_user
    if users_sections_by_name.include?(params["name"])
      @current_section = user_sections.find{|section| section.name == params["name"]}
      redirect "/sections/#{@current_section.id}?error=Section already exists"
    else
      @section = Section.new(name: params["name"])
      @section.user_id = @user.id
      @section.save
      redirect "/users/#{@user.slug}/sections"
    end
  end

  post '/sections/:id' do
    #raise params.inspect

    @section = Section.find_by_id(params[:id])
    if params["name"] != ""
      @section.name = params["name"]
      @section.save
      redirect "/sections/#{@section.id}"
    else
      redirect "/sections/#{@section.id}/edit?error=No empty fields allowed"
    end
  end
end #class 

#################### OLD VERSION ##################
  #### is it useful to have a list of other students
  #### sections? might show repeats.
  #get '/sections' do 
    #if logged_in?
      #@user = current_user
      #@sections = Section.all
      #erb :'/sections/sections'
    #else
      #redirect_if_not_logged_in
    #end
  #end
####### 








