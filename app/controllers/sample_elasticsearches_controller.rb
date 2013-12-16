require "open-uri"
require "translation"

class SampleElasticsearchesController < ApplicationController

  def initialize
    @request_url = "http://59.106.182.98:9200/news/page/_search?pretty&fields=link,title,description,author,publishedDate&sort=publishedDate:desc&from=0&size=10"
  end

  def list
    rss_list = open(@request_url)
    json_object = JSON.load(rss_list)
    hits = json_object["hits"]["hits"]

    hoge = Translation.new()
    @result_array = Array.new()
    hits.each do |hit|
      title_en = hit["fields"]["title"]
      title_ja = hit["fields"]["description"]
      result = {"article_id" => hit["_id"], "title" => title_en, "title_ja" => title_ja, "author" => hit["fields"]["author"], "published_date" => hit["fields"]["publishedDate"]}
      @result_array.push(result)
    end

  end
end
