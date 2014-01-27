class Experience
  include Mongoid::Document
  include Geocoder::Model::Mongoid

  embedded_in :donatable, polymorphic: true
  field :contact_name, :type => String
  field :location, :type => String
  field :coordinates, :type => Array
  geocoded_by :location
  after_validation :geocode, if: ->(obj){ obj.location.present? and obj.location_changed? }

end
