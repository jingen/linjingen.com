class VideosController < ApplicationController
  before_filter :authenticate_user!, :only => [:update, :destroy]

  def index
  end

  def public_videos
    @videos = Video.public_videos
    respond_to do |format|
      format.html { render :nothing => true }
      format.json { render :json => @videos}
    end
  end

  def user_videos
    if user_signed_in?
      @user_videos = current_user.videos
      render :json => @user_videos
    else
      render :json => {}
    end
  end

  def process_link
    video = Video.new_video(params[:video_link])
    store_video(video.id) unless video.nil?
    render :json => video
  end

  def create 
    @new_video = processing_video
    set_user(@new_video)
    if @new_video.update_attributes(video_params)
      render :json => true, status: :ok
    else
      render :json => @new_video.errors, status: :unprocessable_entity
    end
  end

  def update
    @updating_video = current_user.videos.find(params[:video][:id])
    if @updating_video.update_attributes(video_params)
      render :json => true, status: :ok
    else
      render :json => @updating_video.errors, status: :unprocessable_entity
    end
  end

  def destroy
    current_user.videos.find(params[:id]).destroy
    respond_to do |format|
      format.html { render :nothing => true }
      format.json { head :no_content }
    end
  end

  private

  def store_video(videoId)
    session[:processing_video_id] = videoId 
  end

  def processing_video
    Video.find(session[:processing_video_id]) unless session[:processing_video_id].nil?
  end

  def video_params
    if params[:video].present?
      params[:video][:temporary] = false
      params[:video][:to_public] = true unless user_signed_in?
      params.require(:video).permit(:title, :description, :to_public, :temporary)
    end
  end
end
