require 'hpricot'
require "open-uri"
require 'extractcontent'
require 'translation'

class ArticlesController < ApplicationController
  def initialize
    @request_url = "http://59.106.182.98:9200/news/page/_search?pretty&fields=feedname,link,title,description,author,publishedDate&sort=publishedDate:desc"
  end

  def index(limit = "&from=0&size=30")

    rss_list = open(@request_url + limit)
    json_object = JSON.load(rss_list)
    hits = json_object["hits"]["hits"]

    @result_array = Array.new()
    hits.each do |hit|
      title_en = hit["fields"]["title"]
      title_ja = hit["fields"]["description"]

      case hit["fields"]["feedname"]
      when "dailymail" then
        feedname = "England : Daily Mail"
        label_style = "label label-default"
      when "dailytelegraph" then
        feedname = "England : The Daily Telegraph"
        label_style = "label label-default"
      when "telegraph" then
        feedname = "England : The Daily Telegraph"
        label_style = "label label-default"
      when "independent" then
        feedname = "England : The Independent"
        label_style = "label label-default"
      when "Evening Standard" then
        feedname = "England : Evening Standard"
        label_style = "label label-default"
      when "MARCA" then
        feedname = "Spain : MARCA"
        label_style = "label label-danger"
      when "mundo deportivo" then
        feedname = "Spain : El Mundo Deportivo"
        label_style = "label label-danger"
      when "sport" then
        feedname = "Spain : SPORT"
        label_style = "label label-danger"
      when "gazzetta dello sport" then
        feedname = "Italy : La Gazzetta dello Sport"
        label_style = "label label-success"
      when "corriere dello sport" then
        feedname = "Italy : Corriere dello Sport"
        label_style = "label label-success"
      when "tutto sport" then
        feedname = "Italy : Tuttosport"
        label_style = "label label-success"
      when "build" then
        feedname = "Germany : Bild-Zeitung"
        label_style = "label label-warning"
      when "kicker" then
        feedname = "Germany : Kicker-Sportmagazin"
        label_style = "label label-warning"
      when "Lequipe" then
        feedname = "France : L'Equip"
        label_style = "label label-info"
      when "Le Monde" then
        feedname = "France : Le Monde"
        label_style = "label label-info"
      end

      result = {"article_id" => hit["_id"], "title" => title_en, "title_ja" => title_ja, "author" => hit["fields"]["author"],
        "published_date" => hit["fields"]["publishedDate"], "link" => hit["fields"]["link"], "feedname" => feedname, "label_style" => label_style}
      @result_array.push(result)
    end

  end

  def page
    pageno = params[:pageno].to_i

    from = (pageno - 1) * 30 + 1
    limit = "&from=" + from.to_s + "&size=30"

    logger.debug("limit: " + limit);

    index(limit)
  end

  def search

    feedname = params[:feedname]
    keyword = params[:keyword]

    if feedname != nil then
      logger.debug("feedname :" + feedname)
      case feedname
      when "england" then
        @request_url = @request_url + "&q=feedname:" + URI.escape("dailymail dailytelegraph telegraph independent \"Evening Standard\"")
      when "spain" then
        @request_url = @request_url + "&q=feedname:" + URI.escape("sport MARCA \"mundo deportivo\"")
      when "germany" then
        @request_url = @request_url + "&q=feedname:" + URI.escape("build kicker")
      when "italy" then
        @request_url = @request_url + "&q=feedname:" + URI.escape("\"gazzetta dello sport\" \"corriere dello sport\" \"tutto sport\"")
      when "france" then
        @request_url = @request_url + "&q=feedname:" + URI.escape("Lequipe \"Le Monde\"")
      else
        @request_url = @request_url + "&q=feedname:" + URI.escape("\"" + feedname + "\"")
      end
    end

    if keyword != nil then
      logger.debug("keyword :" + keyword)
      @request_url = @request_url + "&q=title:" + URI.escape(keyword)
    end

    logger.debug("@request_url :" + @request_url)


    rss_list = open(@request_url)
    json_object = JSON.load(rss_list)
    hits = json_object["hits"]["hits"]

    @result_array = Array.new()
    hits.each do |hit|
      title_en = hit["fields"]["title"]
      title_ja = hit["fields"]["description"]

      case hit["fields"]["feedname"]
      when "dailymail" then
        feedname = "England : Daily Mail"
        label_style = "label label-default"
      when "dailytelegraph" then
        feedname = "England : The Daily Telegraph"
        label_style = "label label-default"
      when "telegraph" then
        feedname = "England : The Daily Telegraph"
        label_style = "label label-default"
      when "independent" then
        feedname = "England : The Independent"
        label_style = "label label-default"
      when "Evening Standard" then
        feedname = "England : Evening Standard"
        label_style = "label label-default"
      when "MARCA" then
        feedname = "Spain : MARCA"
        label_style = "label label-danger"
      when "mundo deportivo" then
        feedname = "Spain : El Mundo Deportivo"
        label_style = "label label-danger"
      when "sport" then
        feedname = "Spain : SPORT"
        label_style = "label label-danger"
      when "gazzetta dello sport" then
        feedname = "Italy : La Gazzetta dello Sport"
        label_style = "label label-success"
      when "corriere dello sport" then
        feedname = "Italy : Corriere dello Sport"
        label_style = "label label-success"
      when "tutto sport" then
        feedname = "Italy : Tuttosport"
        label_style = "label label-success"
      when "build" then
        feedname = "Germany : Bild-Zeitung"
        label_style = "label label-warning"
      when "kicker" then
        feedname = "Germany : Kicker-Sportmagazin"
        label_style = "label label-warning"
      when "Lequipe" then
        feedname = "France : L'Equip"
        label_style = "label label-info"
      when "Le Monde" then
        feedname = "France : Le Monde"
        label_style = "label label-info"
      end

      result = {"article_id" => hit["_id"], "title" => title_en, "title_ja" => title_ja, "author" => hit["fields"]["author"],
        "published_date" => hit["fields"]["publishedDate"], "link" => hit["fields"]["link"], "feedname" => feedname, "label_style" => label_style}
      logger.debug("feedname2 :" + feedname)
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
