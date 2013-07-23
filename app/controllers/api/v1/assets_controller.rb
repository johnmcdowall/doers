# API (v1) [Asset] controller class
class Api::V1::AssetsController < Api::V1::ApplicationController
  # Shows available assets
  def index
    assets = Asset.where(
      :id => params[:ids], :project_id => current_account.projects)
    render :json => assets
  end

  # Shows available asset
  def show
    asset = Asset.find_by!(
      :id => params[:id], :project_id => current_account.projects)
    render :json => asset
  end

  # Updates available asset
  def update
    asset = Asset.find_by!(
      :id => params[:id], :project_id => current_account.projects)

    begin
      asset.update_attributes(asset_params)
      render :json => asset
    rescue Exception => error
      errors = !!error ? [error.message] : asset.errors.messages
      render :json => { :errors => errors }, :status => 400
    end
  end

  # Creates an asset
  def create
    # Try a link, maybe it's a remote file
    maybe_link = new_asset_params[:attachment]
    new_asset_params[:attachment] = URI.parse(maybe_link) rescue maybe_link

    begin
      # TODO: Handle different asset type when more are available
      asset = current_account.images.create!(new_asset_params)
      render :json => asset
    rescue Exception => error
      errors = !!error ? [error.message] : asset.errors.messages
      render :json => { :errors => errors }, :status => 400
    end
  end

  # Destroys the asset
  def destroy
    asset = Asset.find_by(
      :id => params[:id], :project_id => current_account.projects)
    if asset and asset.destroy
      render :nothing => true, :status => 204
    else
      render :nothing => true, :status => 400
    end
  end

  private

    # Strong parameters for updating a new asset
    def asset_params
      params[:asset] = params[:asset].except(
        :board_id, :type, :project_id, :assetable_id, :assetable_type)
      params.require(:asset).permit(:description, :attachment)
    end

    # Strong parameters for creating a new asset
    def new_asset_params
      params.require(:asset).permit(:description, :board_id, :type,
        :project_id, :assetable_id, :assetable_type, :attachment)
    end
end
