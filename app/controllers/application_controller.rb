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
      #@user = current_user
      redirect "/users/#{current_user.slug}/sections"
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

    def logged_in? 
      !!current_user
    end

    def current_user 
      @current_user ||= User.find_by_id(session[:user_id]) if session[:user_id]
    end

    def usernames_taken #refactor
      @usernames_taken = []
      @users = User.all
      @users.each do |user|
        @usernames_taken << user.username
      end
      @usernames_taken
    end

    def users_videos #refactor
      @user = current_user
      @videos = Video.all
      @users_videos = @videos.select{|video| video.user_id == @user.id}
    end

    def users_videos_by_link #refactor
      @videos_on_file = []
      users_videos.each do |video|
        @videos_on_file << video.link
      end
      @videos_on_file
    end  

    def user_sections #refactor
      @user = current_user
      @sections = Section.all 
      @users_sections = @sections.select{|section| section.user_id == @user.id}
    end

    def users_sections_by_name #refactor
      @sections_on_file = []
      user_sections.each do |section|
        @sections_on_file << section.name
      end
      @sections_on_file
    end  

  end #helper methods
  

end #class