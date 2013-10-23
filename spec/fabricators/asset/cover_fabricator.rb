Fabricator(:cover, :class_name => Asset::Cover) do
  user
  description { sequence(:description) { Faker::Lorem.paragraph } }
  attachment  { File.open(Rails.root.join('spec/fixtures/test.png')) }
end
