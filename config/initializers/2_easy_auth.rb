EasyAuth.config do |c|
  c.oauth_client(
    :twitter,
    Doers::Config.oauth_providers.twitter.client_id,
    Doers::Config.oauth_providers.twitter.secret_key
  )
end

# Overwrite some twitter oauth identity class methods
Identities::Oauth::Twitter.instance_eval do
  def account_attributes_map
    { :uid => 'screen_name', :screen_name => 'screen_name' }
  end

  def retrieve_uid(token)
    binding.pry
    token.params[:screen_name]
  end
end