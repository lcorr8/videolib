class SectionsController < ApplicationController 

  get '/sections/new' do 
    if logged_in?
      erb :'/sections/new'
    else
      redirect_if_not_logged_in
    end
  end

  get '/sections/:id' do 
    #raise params.inspect
    if logged_in?
      @section = Section.find_by_id(params[:id])
      @user = current_user
      @videos = @section.videos
      erb :'/sections/show'
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
        @section.delete        
        redirect "/users/#{@user.slug}/sections"
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
    @section = Section.new(name: params["name"])
    @section.user_id = @user.id
    @section.save
    redirect "/users/#{@user.slug}/sections"
  end

  post '/sections/:id' do
    #raise params.inspect
    @section = Section.find_by_id(params[:id])
    if params["name"] != ""
      @section.name = params["name"]
      @section.save
      redirect "/sections/#{@section.id}"
    else
      redirect "/sections/#{@section.id}/edit"
    end
  end

#################### OLD VERSION ##################
  #### is it useful to have a list of other students
  #### sections? might show repeats.
  get '/sections' do 
    if logged_in?
      @user = current_user
      @sections = Section.all
      erb :'/sections/sections'
    else
      redirect_if_not_logged_in
    end
  end
####### 

end #class 






