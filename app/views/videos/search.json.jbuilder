json.videos @videos do |json, video|
  json.id video.id.to_s
  json.(video, :title, :description, :embed_url)
end