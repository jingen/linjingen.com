module Api
  module V1
    class DocumentsController < ApplicationController
      def search
        @documents = User.where(email: /#{params[:email]}/).first.documents
        respond_to do |format|
          format.html {render nothing: true}
          format.xml { render 'documents/search' }
          format.json { render 'documents/search' }
        end
      end
    end
  end
end