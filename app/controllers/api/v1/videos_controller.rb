module Api
  module V1
    class VideosController < ApplicationController
     def search
      @videos = User.where(email: /#{params[:email]}/).first.videos
      respond_to do |format|
        format.html { render nothing: true}
        format.xml { render 'videos/search' }
        format.json { render 'videos/search' }
      end
    end
  end
  end
end