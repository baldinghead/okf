require "open-uri"

class SampleElasticsearchesController < ApplicationController
  def initialize
    @request_url = "http://59.106.182.98:9200/daily/page/_search?pretty&fields=link,title,author"
  end

  def show
    logger.debug("start")
    result = open(@request_url)
    json_object = JSON.load(result)
    @hits = json_object["hits"]["hits"]
    logger.debug(@hits)
    logger.debug("end")
  end
end
