class DeployController < ApplicationController
  
  def index
    
    here = File.dirname(__FILE__)
    scriptPath = here + "/../../build.sh"

    logger.info(scriptPath)
    system(scriptPath)
    
    render :nothing => true
  end
  
end
