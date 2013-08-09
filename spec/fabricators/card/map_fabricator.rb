Fabricator('card/map') do
  title      { sequence(:location) { Faker::Address.neighborhood } }
  title_hint { Faker::Lorem.sentence }
  latitude   { Faker::Geolocation.lat.round(10) }
  longitude  { Faker::Geolocation.lng.round(10) }
  user
  board
  project    { nil }
  question   { Faker::Lorem.sentence }
  help       { Faker::Lorem.phrases(4).join("\n") }
  content    { sequence(:addres) { '%s, %s, %s' % [
    Faker::Address.street_address,Faker::Address.city,Faker::Address.country] }}
end
