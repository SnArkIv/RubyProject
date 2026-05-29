json.addresses @addresses do |address|
  json.id address.id
  json.full_name address.full_name
  json.phone address.phone
  json.city address.city
  json.street address.street
  json.house address.house
  json.apartment address.apartment
  json.zip_code address.zip_code
  json.is_default address.is_default
end
