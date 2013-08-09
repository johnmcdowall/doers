Fabricator('card/video') do
  title      { Faker::Lorem.sentence }
  title_hint { Faker::Lorem.sentence }
  video_id   { %w(1D1cap6yETA sTSA_sWGM44 QH2-TGUlwu4).sample }
  provider   { Card::Video::PROVIDERS.sample }
  user
  board
  project    { nil }
  question   { Faker::Lorem.sentence }
  help       { Faker::Lorem.phrases(4).join("\n") }
  after_create do |video_card, trans|
    video_card.image = Fabricate.build(
      :image, :user => video_card.user, :board => video_card.board,
      :assetable => video_card, :project => video_card.project)
  end
end
