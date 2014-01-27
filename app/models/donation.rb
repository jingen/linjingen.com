class Donation
  include Mongoid::Document
  include Mongoid::Timestamps
  embeds_one :item, :as => :donatable
  belongs_to :user
  field :title, :type => String
  field :description, :type => String
  field :type, :type => String

  def self.create_donation(item_params)
    donation = new(title: item_params[:title], description: item_params[:description], type: item_params[:type])
    case item_params[:type]
    when "physical_item"
      donation.item = PhysicalItem.new(width: item_params[:width], height: item_params[:height], weight: item_params[:weight])
    when "voucher"
      donation.item = Voucher.new(expiration_date: DateTime.parse(item_params[:expiration_date]))
    when "experience"
      donation.item = Experience.new(contact_name: item_params[:contact_name], location: item_params[:location])
    end
    donation
  end
end
