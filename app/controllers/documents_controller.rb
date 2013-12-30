class DocumentsController < ApplicationController
  # protect_from_forgery :only => [:update, :delete, :create]
  protect_from_forgery :except => [:webhook]
  # skip_before_filter :verify_authenticity_token
  before_filter :authenticate_user!, :only => [:update, :destroy]
  before_filter :parse_doc_params, :only => [:create, :update]

  def index
  end

  def public_docs
    @docs = Document.public_docs
    render :json => @docs
  end

  def user_docs
    if user_signed_in?
      @user_docs = current_user.documents 
      render :json => @user_docs
    else
      render :json => {}
    end
  end

  def crocodoc_session
    @session_key = Crocodoc::Session.create(params[:croc_uuid], session_param) if params[:croc_uuid].present?
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
    if user_signed_in?
      {
        'is_editable' => true,
        'user'        => {
          'id' => current_user.unique_id,
          'name' => current_user.email
        },
        'is_downloadable' => true,
        'sidebar' => 'collapse'
      }
    else
      {
        'is_downloadable' => true,
        'sidebar' => 'collapse'
      }
    end
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
    set_user(@document)
    if @document.save
      render json: @document, status: :ok
    else
      render json: @document.errors , status: :unprocessable_entity 
    end
  end

  def update
    @document = current_user.documents.find(params[:document][:id])
    if @document.update_attributes(document_params)
      render json: @document, status: :ok
    else
      render json: @document.errors , status: :unprocessable_entity 
    end
  end

  def destroy
    current_user.documents.find(params[:id]).destroy_with_croc
    # render json: true, status: :ok
    respond_to do |format|
      format.html { render :nothing => true }
      format.json { head :no_content }
    end
  end

  private

  def parse_doc_params
    if params[:document].present?
      params[:document] = JSON.parse(params[:document])
      params[:document][:file] = params[:file] if params[:file].present?
    end
  end

  def document_params
    params[:document][:to_public] = true unless user_signed_in?
    params.require(:document).permit(:title, :description, :to_public, :file)
  end
end
