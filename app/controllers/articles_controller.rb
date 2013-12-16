require 'hpricot'
require "open-uri"
require 'extractcontent'
require 'translation'

class ArticlesController < ApplicationController
  def initialize
    @request_url = "http://59.106.182.98:9200/news/page/_search?pretty&fields=feedname,link,title,description,author,publishedDate&sort=publishedDate:desc&from=0&size=10"
  end

  def index
    rss_list = open(@request_url)
    json_object = JSON.load(rss_list)
    hits = json_object["hits"]["hits"]

    hoge = Translation.new()
    @result_array = Array.new()
    hits.each do |hit|
      title_en = hit["fields"]["title"]
      title_ja = hit["fields"]["description"]

      case hit["fields"]["feedname"]
      when "dailymail" then
        feedname = "England : Daily Mail"
      when "dailytelegraph" then
        feedname = "England : The Daily Telegraph"
      when "telegraph" then
        feedname = "England : The Daily Telegraph"
      when "independent" then
        feedname = "England : The Daily Telegraph"
      when "Evening Standard" then
        feedname = "England : The Daily Telegraph"
      end

      result = {"article_id" => hit["_id"], "title" => title_en, "title_ja" => title_ja, "author" => hit["fields"]["author"],
        "published_date" => hit["fields"]["publishedDate"], "link" => hit["fields"]["link"], "feedname" => feedname}
      @result_array.push(result)
    end

  end

  def search
    keyword = params[:keyword]
    logger.debug("keyword :" + keyword)
    @request_url = @request_url + "&q=title:" + keyword

    rss_list = open(@request_url)
    json_object = JSON.load(rss_list)
    hits = json_object["hits"]["hits"]

    hoge = Translation.new()
    @result_array = Array.new()
    hits.each do |hit|
      title_en = hit["fields"]["title"]
      title_ja = hit["fields"]["description"]

      case hit["fields"]["feedname"]
      when "dailymail" then
        feedname = "England : Daily Mail"
      when "dailytelegraph" then
        feedname = "England : The Daily Telegraph"
      when "telegraph" then
        feedname = "England : The Daily Telegraph"
      when "independent" then
        feedname = "England : The Daily Telegraph"
      when "Evening Standard" then
        feedname = "England : The Daily Telegraph"
      end

      result = {"article_id" => hit["_id"], "title" => title_en, "title_ja" => title_ja, "author" => hit["fields"]["author"],
        "published_date" => hit["fields"]["publishedDate"], "link" => hit["fields"]["link"], "feedname" => feedname}
      @result_array.push(result)
    end

    render "index"
  end

  def show
    article_id = params[:id]
    logger.debug("article_id : " + article_id)

    # DBを検索
    article = Article.find_by article_id: article_id

    if article == nil then
      # データが存在しない場合はelasticsearchからのデータを翻訳してDBに登録
      logger.debug("article not found.")

      # elasticsearchからデータを取得
      url = "http://59.106.182.98:9200/news/page/" + article_id + "?pretty&fields=link,title,description&sort=publishedDate"
      article = open(url)
      json_object = JSON.load(article)
      link = json_object["fields"]["link"]
      @title_en = json_object["fields"]["title"]
      @title_ja = json_object["fields"]["description"]

      doc = Hpricot(open(link).read)
      @body_en, title = ExtractContent.analyse(doc.to_html)
      trasnlation = Translation.new()
      @body_ja = trasnlation.trans(@body_en)

      Article.new(:article_id => article_id, :title_en_auto => @title_en, :title_ja_auto => @title_ja, :content_en_auto => @body_en, :content_ja_auto => @body_ja).save

    else
      # データが存在すれば返却
      logger.debug("article found.")
      @title_en = article.title_en_auto
      @body_en = article.content_en_auto
      @body_ja = article.content_ja_auto

    end

  end
end
