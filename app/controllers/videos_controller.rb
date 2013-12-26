class VideosController < ApplicationController
  def index
  end

  def process_link
    video = Video.new_video(params[:video_link])
    render :json => video
  end
end
