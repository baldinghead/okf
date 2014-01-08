require 'idobata'

class FeedbacksController < ApplicationController
  def index
    logger.debug("start feedback.")
    feedback = params[:feedback]

    logger.debug("feedback : " + feedback)
    Idobata.hook_url = "https://idobata.io/hook/d355f124-e7c8-4727-bbd8-65d27442dfec"
    Idobata::Message.create(source: feedback)
    render :nothing => true
  end
end
