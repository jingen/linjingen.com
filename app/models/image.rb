class Image
  include Mongoid::Document
  include Mongoid::Timestamps
  
  field :width, :type =>Integer
  field :height, :type =>Integer
  field :scale, :type =>Integer
  field :resize_method, :type => String, :default => "free"
  mount_uploader :image, ImageUploader
end
