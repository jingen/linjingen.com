json.array! @donations do |donation|
  json.id donation.id.to_s
  json.(donation, :title, :description)
  json.type donation.type
  json.item donation[:item]
end