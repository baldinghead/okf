require "open-uri"

class SampleElasticsearchesController < ApplicationController

  def index
  end

  def initialize
    @request_url = "http://59.106.182.98:9200/daily/page/_search?pretty&fields=link,title,author,publishedDate&sort=publishedDate:desc&from=0&size=10"
  end

  def list
    logger.debug("start")
    rss_list = open(@request_url)
    json_object = JSON.load(rss_list)
    hits = json_object["hits"]["hits"]

    # TODO 翻訳した値をいれる
    title_ja = "イングランドマネージャーロイホジソンはその出発の場所を得るためにアシュリー?コール、フランク?ランパードとジャック?ウィルシャーが必要"

    @result_array = Array.new()
    hits.each do |hit|
      result = {"article_id" => hit["_id"], "title" => hit["fields"]["title"], "title_ja" => title_ja, "author" => hit["fields"]["author"], "published_date" => hit["fields"]["publishedDate"]}
      @result_array.push(result)
    end

    logger.debug("end")
  end

  def show
    article_id = params[:id];
  end
end
