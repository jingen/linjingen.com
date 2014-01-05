json.documents @documents do |document|
  json.id document.id.to_s
  json.(document, :title, :description, :croc_uuid)
end