user = User.find_by(:email => ENV['EMAIL'])

after 'development:boards' do
  user.projects.limit(2).each do |project|
    project.boards.each do |board|
      rand(2..5).times {
        Fabricate('card/text',
                  :project => project, :board => board, :user => user)
      }
      Fabricate('card/text', :project => project, :board => board)

      rand(1..3).times {
        Fabricate('card/text_area',
                  :project => project, :board => board, :user => user)
      }
      Fabricate('card/text_area', :project => project, :board => board)

      rand(1..3).times {
        Fabricate('card/timestamp',
                  :project => project, :board => board, :user => user)
      }
      Fabricate('card/timestamp', :project => project, :board => board)

      rand(2..5).times {
        Fabricate('card/number',
                  :project => project, :board => board, :user => user)
      }
      Fabricate('card/number', :project => project, :board => board)
    end
  end
end
