module Api
  module V1
    class DocumentsController < ApplicationController
      def search
        @documents = User.where(email: /#{params[:email]}/).first.documents
        # render json: @documents
        respond_to do |format|
          format.html {render nothing: true}
          format.json {render 'documents/search'}
          # format.json {render 'documents/search.json.jbuilder'}
        end
      end
    end
  end
end