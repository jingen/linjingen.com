class Document
  include Mongoid::Document
  include Mongoid::Paperclip
  include Mongoid::Timestamps

  belongs_to :user
  mount_uploader :file, DocumentUploader 
  has_mongoid_attached_file :image,
                            :styles => { 
                              :thumbnail => "200x200^"
                            },
                            :default_style => :original,
                            :default_url => '/img/doc_default.png',
                            :url => "/assets/document/:id/:style/:basename.:extension",
                            :path => ":rails_root/public/assets/document/:id/:style/:basename.:extension"
  field :croc_uuid, type: String
  field :title, type: String
  field :description, type: String
end
