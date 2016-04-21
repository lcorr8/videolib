require 'pry'

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
      redirect "/users/#{@user.slug}/sections"
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

####### refactor to work properly, currently not checking if video belongs to user, only checking if user is logged in #####
    #def redirect_if_not_your_section
#      @user = current_user
#      if @user.id != params[:user_id]
#        redirect "/users/#{@user.slug}/sections?error=Not your section to edit"
#      end
#    end
#    
#    def redirect_if_not_your_video
#      @user = current_user
#      if @user.id != params[:user_id]
#        redirect "/users/#{@user.slug}/videos?error=Not your video to edit"
#      end
#    end

    def logged_in?
      !!session[:user_id]
    end

    def current_user
      User.find(session[:user_id])
    end

    def usernames_taken
      @usernames_taken = []
      @users = User.all
      @users.each do |user|
        @usernames_taken << user.username
      end
      @usernames_taken
    end

    def users_videos
      @user = current_user
      @videos = Video.all
      @users_videos = @videos.select{|video| video.user_id == @user.id}
    end

    def users_videos_by_link
      @videos_on_file = []
      users_videos.each do |video|
        @videos_on_file << video.link
      end
      @videos_on_file
    end  

    def user_sections
      @user = current_user
      @sections = Section.all 
      @users_sections = @sections.select{|section| section.user_id == @user.id}
    end

    def users_sections_by_name
      @sections_on_file = []
      user_sections.each do |section|
        @sections_on_file << section.name
      end
      @sections_on_file
    end  

  end #helper methods
  

end #class