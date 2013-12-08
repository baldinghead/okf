require "open-uri"
require "translation"

class SampleElasticsearchesController < ApplicationController

  def initialize
    @request_url = "http://59.106.182.98:9200/news/page/_search?pretty&fields=link,title,author,publishedDate&sort=publishedDate:desc&from=0&size=10"
  end

  def list
    logger.debug("start")
    rss_list = open(@request_url)
    json_object = JSON.load(rss_list)
    hits = json_object["hits"]["hits"]

    # TODO 翻訳した値をいれる
    title_ja = "イングランドマネージャーロイホジソンはその出発の場所を得るためにアシュリー?コール、フランク?ランパードとジャック?ウィルシャーが必要"

    logger.debug("prepare trans")
    hoge = Translation.new()
    @result_array = Array.new()
    hits.each do |hit|
      title = hit["fields"]["title"]
      logger.debug("trans start")
      # title_ja = hoge.trans(title)
      logger.debug("trans end")
      result = {"article_id" => hit["_id"], "title" => title, "title_ja" => title_ja, "author" => hit["fields"]["author"], "published_date" => hit["fields"]["publishedDate"]}
      @result_array.push(result)
    end

    logger.debug("end")
  end
end
