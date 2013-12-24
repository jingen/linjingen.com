class Document
  include Mongoid::Document
  include Mongoid::Paperclip
  include Mongoid::Timestamps

  belongs_to :user
  mount_uploader :file, DocumentUploader 
  has_mongoid_attached_file :image,
                            :styles => { 
                              :thumbnail => ["200x200^", :jpg]
                            },
                            :default_style => :original,
                            :default_url => '/img/doc_default.png',
                            :url => "/assets/document/:id/:style/:basename.:extension",
                            :path => ":rails_root/public/assets/document/:id/:style/:basename.:extension"
  field :croc_uuid, type: String
  field :title, type: String
  field :description, type: String
  field :public, type: Boolean, default: false

  scope :public_docs, where(public: true)

  after_save :upload_to_crocodoc

  def gen_thumbnail
    self.image = StringIO.new(Crocodoc::Download.thumbnail(self.croc_uuid, 200, 200))
    self.save
  end

  def as_json(options)
    {
      id: self.id.to_s,
      title: self.title,
      description: self.description,
      croc_uuid: self.croc_uuid,
      thumbnail: self.image.url(:thumbnail)
    }
  end

  protected

  def upload_to_crocodoc
    if self.file.present? && self.file_filename_changed?
      self.set(:croc_uuid => Crocodoc::Document.upload(File.open(self.file.path, 'r')))
    end
  end

end
