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
    @error_message = params[:error]
    if logged_in?
      if @section = current_user.sections.find_by_id(params[:id]) 
        erb :'/sections/show'
      else
        redirect "/users/#{current_user.slug}/sections?error=Not your section to view, see your sections below"
        #erb :'/sections/your_sections', locals:{message:"Not your section to view, see your sections below"}
      end
    else
      redirect_if_not_logged_in
    end
  end

  get '/sections/:id/edit' do 
    @error_message = params[:error]
    if logged_in?
       if @section = current_user.sections.find_by_id(params[:id]) 
        erb :'/sections/edit'
      else  
        redirect "/users/#{current_user.slug}/sections?error=Not your section to edit, see your sections below"
        #erb :'/sections/your_sections', locals:{message:"Not your section to edit, see your sections below"}
      end
    else
      redirect_if_not_logged_in
    end
  end

  get '/sections/:id/delete' do 
    if logged_in?
      if @section = current_user.sections.find_by_id(params[:id])
        if @section.videos.count == 0
          @section.delete        
          redirect "/users/#{current_user.slug}/sections"
        else
          redirect "/users/#{current_user.slug}/sections?error=Unable to delete section because it still contains videos"
          #erb :'/sections/your_sections', locals:{message:"Unable to delete section because it still contains videos"}
        end
      else
        redirect "/users/#{current_user.slug}/sections?error=Not your section to delete"
        #erb :'/sections/your_sections', locals:{message:"Not your section to delete, see your sections below"}
      end
    else
      redirect_if_not_logged_in
    end
  end

  post '/sections' do 
    if users_sections_by_name.include?(params["name"])
      @current_section = user_sections.find{|section| section.name == params["name"]}
      redirect "/sections/#{@current_section.id}?error=Section already exists"
    else
      @section = Section.new(name: params["name"])
      @section.user_id = current_user.id
      @section.save
      redirect "/users/#{current_user.slug}/sections"
    end
  end

  post '/sections/:id' do
    @section = Section.find_by_id(params[:id])
    @section.name = params["name"]
    @section.save
    redirect "/sections/#{@section.id}"
  end
end #class 





