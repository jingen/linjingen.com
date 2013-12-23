class DocumentsController < ApplicationController
  # protect_from_forgery :only => [:update, :delete, :create]
  protect_from_forgery :except => [:webhook]
  # skip_before_filter :verify_authenticity_token

  def index
  end

  def webhook
    payload = JSON.parse(params[:payload]) if params[:payload].present?
    puts payload
    puts "payload!!!"
    payload.each do |crocodoc|
      doc = Document.where(croc_uuid: crocodoc[:uuid]).first
      if crocodoc[:status] == "DONE" && crocodoc[:viewable]
        doc.gen_thumbnail
      end
      puts doc
    end
    render :nothing => true
  end

  def create
    @document = Document.new(document_params)
    if @document.save
      render json: @document
    else
      render json: @document.errors , status: :unprocessable_entity 
    end
  end

  def destroy
  end

  private

  def document_params
    if params[:file].present?
      params[:document] = JSON.parse(params[:document])
      params[:document][:file] = params[:file]
    end
    params.require(:document).permit(:title, :description, :file)
  end
end
