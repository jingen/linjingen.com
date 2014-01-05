xml.videos do 
  @videos.each do |video|
    xml.video do
      xml.id video.id.to_s
      xml.title video.title
      xml.description video.description
      xml.embed_url video.embed_url
    end
  end
end
