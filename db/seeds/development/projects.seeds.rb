user = User.find_by(:email => ENV['EMAIL'])

after 'development:users' do
  # My projects
  5.times { Fabricate(:project_with_invitations, :user => user) }
  # Other projects
  15.times { Fabricate(:project) }
end
