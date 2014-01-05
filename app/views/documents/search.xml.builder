xml.documents do
  @documents.each do |document|
    xml.document do
      xml.id document.id.to_s
      xml.title document.title
      xml.description document.description
      xml.croc_uuid document.croc_uuid
    end
  end
end