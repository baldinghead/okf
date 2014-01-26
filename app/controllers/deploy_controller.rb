class DeployController < ApplicationController
  
  skip_before_action :verify_authenticity_token
  protect_from_forgery with: :null_session
    
  def index
    here = File.dirname(__FILE__)
    scriptPath = here + "/../../build.sh"
    #デプロイシェルを実行
    system(scriptPath)
    
    logger.info("params=" + params)
    logger.info("params=" + params)
    requestObj = ActiveSupport::JSON.decode(params)
    
    logger.info(params['payload']['commits'][0])
    author = params['payload']['commits'][0]['author']
    branch = params['payload']['commits'][0]['branch']
    message = "author= " + author + '  branch=' + branch + "<br />" + params['payload']['commits'][0]['message']
    
    logger.info("message=" + message)
    
    curlCmd = 'curl --data-urlencode "source=' + message + '" -d format=html https://idobata.io/hook/4a11714e-6b1a-41fb-9cd3-3f533ce70e92'
    logger.info(curlCmd)
    system(curlCmd)
    
    
    render :nothing => true
  end
  
end
