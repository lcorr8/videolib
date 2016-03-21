require './config/environment'

class ApplicationController < Sinatra::Base

  configure do
    set :public_folder, 'public'
    set :views, 'app/views'
    enable :sessions
    set :session_secret, "videolecturesforme"
  end

get '/' do 
  if logged_in?
    @user = current_user
    redirect redirect "/users/#{@user.slug}/sections"
  else
     erb :index
  end
end

  helpers do
    def redirect_if_not_logged_in
      if !logged_in?
        redirect "/login?error=You have to be logged in to do that"
      end
    end

    def redirect_if_not_your_section
      @user = current_user
      if @user.id != params[:user_id]
        redirect "/users/#{@user.slug}/sections?error=Not your section to edit"
      end
    end

    def redirect_if_not_your_video
      @user = current_user
      if @user.id != params[:user_id]
        redirect "/users/#{@user.slug}/videos?error=Not your section to edit"
      end
    end

    def logged_in?
      !!session[:user_id]
    end

    def current_user
      User.find(session[:user_id])
    end


    


  end #helper methods
  

end #class