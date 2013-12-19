class WordsController < ApplicationController
  skip_before_filter :verify_authenticity_token 

  def index
  end
  
  # deal with the spell checking request, send back the results
  def check
    result = AfterTheDeadline.check params[:words]
    render json: result
  end
end
