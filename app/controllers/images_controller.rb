class ImagesController < ApplicationController
  skip_before_filter :verify_authenticity_token

  def index
  end

  # deal with the image resizing request and send back the results
  def create 
    @image ||= Image.new(image_params)
    if @image.save
      render json: {"url" => @image.image_url(:resized), "success" => true}
    else
      render json: @image.errors, status: :unprocessable_entity
    end
  end

  private

  # construct image arguments
  def image_params
    if params[:file].present?
      params[:image] = JSON.parse(params[:image])
      params[:image][:image] = params[:file]
    end
    params.require(:image).permit(:width, :height, :scale, :resize_method, :remote_image_url, :image)
  end
end
