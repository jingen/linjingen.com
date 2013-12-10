class UsersController < ApplicationController
  def avatar
    if request.post?
      current_user.update_attributes(avatar: params[:file])
    end
    render :json => {
      nav_avatar: current_user.avatar.url(:small), 
      avatar:     current_user.avatar.url(:medium)
    }
  end
end
