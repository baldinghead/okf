require "open-uri"

class SampleElasticsearchesController < ApplicationController
  def initialize
    @request_url = "http://59.106.182.98:9200/daily/page/_search?pretty"
  end

  def show
    logger.debug("start")
    result = open(@request_url)
    json_object = JSON.load(result)
    logger.debug(json_object)
    logger.debug("end")
  end
end
