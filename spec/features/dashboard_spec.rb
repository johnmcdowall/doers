require 'spec_helper'

feature 'User Dashboard', :js, :vcr => {:cassette_name => :twitter_oauth} do

  background do
    sign_in_with_twitter
  end

  scenario 'when logged in user can see the dashboard' do
    visit "/#dashboard"

    expect(page).to have_css('#projects')
  end
end