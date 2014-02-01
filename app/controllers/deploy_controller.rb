class DeployController < ApplicationController

  skip_before_action :verify_authenticity_token
  protect_from_forgery with: :null_session

  def index
    here = File.dirname(__FILE__)
    scriptPath = here + "/../../build.sh"
    #デプロイシェルを実行
    system(scriptPath)
    #JSONのパース
    paramObj = ActiveSupport::JSON.decode(params["payload"])
    logger.info(paramObj['commits'])
    message=""
    for commit in paramObj['commits'] do
      line=""
      
      if commit['author'] then
        line += "author= " + commit['author']
      end
      if commit['branch'] then
        line += "branch= " + commit['branch']
      end
      if commit['message'] then
        line += "<br />" + commit['message']
      end
      line += "<br />"
      
      message += line
    end 

    curlCmd = 'curl --data-urlencode "source=' + message + '" -d format=html https://idobata.io/hook/4a11714e-6b1a-41fb-9cd3-3f533ce70e92'
    logger.info(curlCmd)
    system(curlCmd)

    render :nothing => true
  end

end