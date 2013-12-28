class Video
  include Mongoid::Document
  include Mongoid::Timestamps

  belongs_to :user

  field :video_id, type: String 
  field :provider, type: String 
  field :title, type: String 
  field :description, type: String 
  field :duration, type: String 
  field :date, type: String 
  field :thumbnail_small, type: String 
  field :thumbnail_medium, type: String 
  field :thumbnail_large, type: String 
  field :embed_url, type: String 
  field :embed_code, type: String 
  field :to_public, type: Boolean, default: false
  field :temporary, type: Boolean, default: true

  scope :public_videos, where({to_public: true, temporary: false})

  def self.new_video(video_link)
    video_info = VideoInfo.new(video_link, referer: "http://www.urappzone.com", user_agent: "urappzone")
    create ({
          video_id:         video_info.video_id, 
          provider:         video_info.provider,
          title:            video_info.title,
          description:      video_info.description,
          duration:         video_info.duration,
          date:             video_info.date,
          thumbnail_small:  video_info.thumbnail_small,
          thumbnail_medium: video_info.thumbnail_medium,
          thumbnail_large:  video_info.thumbnail_large,
          embed_url:        video_info.embed_url,
          embed_code:       video_info.embed_code
        })
  end

  def as_json(options)
    {
      id: self.id.to_s,
      title: self.title,
      description: self.description,
      thumbnail_medium: self.thumbnail_medium,
      embed_url: self.embed_url,
      to_public: self.to_public
    }
  end
end

