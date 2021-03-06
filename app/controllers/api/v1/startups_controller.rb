# API (v1) startups controller class
class Api::V1::StartupsController < Api::V1::ApplicationController
  # Does nothing, makes Ember Data happy!
  def index
    render :nothing => true, :status => 200
  end

  # Handles startups import
  def create
    sid = startup_params[:external_id].to_s
    startup = current_account.projects.find_by(:external_id => sid)

    if !startup
      current_account.update_attributes(:importing => true)
      Delayed::Job.enqueue(ImportJob.new(current_account, sid))

      render :json => {:startup => {:external_id => sid}}, :status => 200
    else
      error = _('Failed to import a duplicate.')
      render :json => {:errors => [error], :startup => startup}, :status => 400
    end
  end

  private
    # Strong parameters for creating a startup import
    def startup_params
      params.require(:startup).permit(:external_id)
    end
end
