class Voucher
  include Mongoid::Document

  embedded_in :donatable, polymorphic: true
  field :expiration_date, :type => DateTime
end
