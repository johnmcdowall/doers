# API (v1) users controller class
class Api::V1::UsersController < Api::V1::ApplicationController

  # Lists available users
  def index
    render :json => [current_account]
  end

  # Shows current user
  def show
    render :json => current_account
  end
end