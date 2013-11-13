class SampleSolrsController < ApplicationController
  def initialize

    # @solr = RSolr::Connection.new('http://59.106.182.98:8983/solr', :autocommit => :on);
url = "http://59.106.182.98:8983/solr"
@solr = RSolr.connect :url => url
  end

  def index
  end
  
  def show
    logger.debug("hogehoge")
    res = @solr.get 'select', :params => {:q=>'*:*'}

    logger.debug(res)
  end
end
