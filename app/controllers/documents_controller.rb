class DocumentsController < ApplicationController
  # protect_from_forgery :only => [:update, :delete, :create]
  protect_from_forgery :except => [:webhook]
  # skip_before_filter :verify_authenticity_token
  before_filter :authenticate_user!, :only => [:user_docs]

  def index
  end

  def public_docs
    @docs = Document.public_docs
    render :json => @docs
  end

  def user_docs
    @user_docs = current_user.documents if user_signed_in?
    render :json => @user_docs
  end

  def crocodoc_session
    @session_key = Crocodoc::Session.create(params[:croc_uuid]) if params[:croc_uuid].present?
    unless @session_key.nil?
      render json: {session_key: @session_key, view_url: get_view_url}, status: :ok
    else
      render json: {error: "can not get session key"}, status: :unprocessable_entity
    end
  end

  def get_view_url
    @view_url = "https://crocodoc.com/view/" + @session_key
  end

  def session_param
    {
      'is_downloadable' => true,
      'sidebar' => 'visible'
    }
  end

  def webhook
    payload = JSON.parse(params[:payload]) if params[:payload].present?
    payload.each do |crocodoc|
      doc = Document.where(croc_uuid: crocodoc["uuid"]).first
      if !doc.nil? && crocodoc["status"] == "DONE" && crocodoc["viewable"]
        doc.gen_thumbnail
      end
    end
    render :nothing => true
  end

  def create
    @document = Document.new(document_params)
    @document.user = current_user if user_signed_in?
    if @document.save
      render json: @document, status: :ok
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
    params[:public] = true unless user_signed_in?
    params.require(:document).permit(:title, :description, :public, :file)
  end
end
