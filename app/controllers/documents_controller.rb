class DocumentsController < ApplicationController
  def index
  end

  def webhook
    logger.debug params
  end

  def create
    @document = Document.new(document_params)
    if @document.save
      redirect_to doc_library_path
    else
      redirect_to root_path
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
