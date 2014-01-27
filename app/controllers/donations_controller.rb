class DonationsController < ApplicationController
  def index
  end

  def create
    @donation = Donation.create_donation(donation_params)
    set_user(@donation)
    if @donation.save
      render json: @donation, status: :ok
    else
      render json: @donation.errors , status: :unprocessable_entity 
    end
  end

  def donation_history
    if user_signed_in?
      @donations = current_user.donations
      respond_to do |format|
        format.html { render nothing: true}
        format.json
      end
    else
      render :json => {}
    end
  end

  private
  def donation_params
    case params[:donation][:type]
    when "physical_item"
      params.require(:donation).permit(:title, :description, :type, :width, :height, :weight)
    when "voucher"
      params.require(:donation).permit(:title, :description, :type, :expiration_date)
    when "experience"
      params.require(:donation).permit(:title, :description, :type, :contact_name, :location)
    end
  end
end
