class PhysicalItem
  include Mongoid::Document

  embedded_in :donatable, polymorphic: true
  field :width, :type => Integer
  field :height, :type => Integer
  field :weight, :type => Integer
end
