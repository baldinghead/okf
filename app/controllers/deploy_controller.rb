class DeployController < ApplicationController
  
  skip_before_action :verify_authenticity_token
  protect_from_forgery with: :null_session
    
  def index
    here = File.dirname(__FILE__)
    scriptPath = here + "/../../build.sh"

    logger.info(scriptPath)
    system(scriptPath)
    
    
    render :nothing => true
  end
  
end
