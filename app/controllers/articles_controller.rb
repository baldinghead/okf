require 'hpricot'
require "open-uri"
require 'extractcontent'
require 'translation'

class ArticlesController < ApplicationController
  def initialize
    #@request_url = "http://54.199.172.167:9200/news/page/_search?pretty&fields=feedname,link,title,description,japaneseDesc,author,publishedDate&sort=publishedDate:desc"
    @request_url = "http://localhost:9200/news/page/_search?pretty&fields=feedname,link,title,description,japaneseDesc,author,publishedDate&sort=publishedDate:desc"
    @search_feedname
    @keyword
    @title_tag_value = "海外サッカーニュースならOKfoot"
    @meta_description_value = "海外サッカーニュースを収集する日本最大級のサイトです。現在はイギリス、スペイン、ドイツ、イタリア、フランスのニュースを収集しています。今後は南米やアジア圏も視野にいれていきたいです。"
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
        desc_style = "bs-callout bs-callout-default"
      when "dailytelegraph" then
        feedname = "England : The Daily Telegraph"
        label_style = "label label-default"
        desc_style = "bs-callout bs-callout-default"
      when "telegraph" then
        feedname = "England : The Daily Telegraph"
        label_style = "label label-default"
        desc_style = "bs-callout bs-callout-default"
      when "independent" then
        feedname = "England : The Independent"
        label_style = "label label-default"
        desc_style = "bs-callout bs-callout-default"
      when "Evening Standard" then
        feedname = "England : Evening Standard"
        label_style = "label label-default"
        desc_style = "bs-callout bs-callout-default"
      when "MARCA" then
        feedname = "Spain : MARCA"
        label_style = "label label-danger"
        desc_style = "bs-callout bs-callout-danger"
      when "mundo deportivo" then
        feedname = "Spain : El Mundo Deportivo"
        label_style = "label label-danger"
        desc_style = "bs-callout bs-callout-danger"
      when "spainsport" then
        feedname = "Spain : SPORT"
        label_style = "label label-danger"
        desc_style = "bs-callout bs-callout-danger"
      when "gazzetta dello sport" then
        feedname = "Italy : La Gazzetta dello Sport"
        label_style = "label label-success"
        desc_style = "bs-callout bs-callout-success"
      when "corrieredellosport" then
        feedname = "Italy : Corriere dello Sport"
        label_style = "label label-success"
        desc_style = "bs-callout bs-callout-success"
      when "tutto sport" then
        feedname = "Italy : Tuttosport"
        label_style = "label label-success"
        desc_style = "bs-callout bs-callout-success"
      when "build" then
        feedname = "Germany : Bild-Zeitung"
        label_style = "label label-warning"
        desc_style = "bs-callout bs-callout-warning"
      when "kicker" then
        feedname = "Germany : Kicker-Sportmagazin"
        label_style = "label label-warning"
        desc_style = "bs-callout bs-callout-warning"
      when "Lequipe" then
        feedname = "France : L'Equip"
        label_style = "label label-info"
        desc_style = "bs-callout bs-callout-info"
      when "Le Monde" then
        feedname = "France : Le Monde"
        label_style = "label label-info"
        desc_style = "bs-callout bs-callout-info"
      end

      result = {"article_id" => hit["_id"], "title" => title_en, "title_ja" => title_ja,
        "author" => hit["fields"]["author"],
        "published_date" => hit["fields"]["publishedDate"],
        "link" => hit["fields"]["link"], "feedname" => feedname,
        "label_style" => label_style, "japaneseDesc" => hit["fields"]["japaneseDesc"], "desc_style" => desc_style}
      @result_array.push(result)
    end

  end

  def page
    pageno = params[:pageno].to_i
    feedname = params[:search_feedname]
    keyword = params[:keyword]


    from = (pageno - 1) * 30 + 1
    limit = "&from=" + from.to_s + "&size=30"

    @request_url = @request_url + limit

    if feedname != nil && feedname != "" then
      logger.debug("feedname :" + feedname)
      case feedname
      when "england" then
        @request_url = @request_url + "&q=feedname:" + URI.escape("dailymail dailytelegraph telegraph independent \"Evening Standard\"")
      when "spain" then
        @request_url = @request_url + "&q=feedname:" + URI.escape("spainsport MARCA \"mundo deportivo\"")
      when "germany" then
        @request_url = @request_url + "&q=feedname:" + URI.escape("build kicker")
      when "italy" then
        @request_url = @request_url + "&q=feedname:" + URI.escape("\"gazzetta dello sport\" corrieredellosport \"tutto sport\"")
      when "france" then
        @request_url = @request_url + "&q=feedname:" + URI.escape("Lequipe \"Le Monde\"")
      else
        @request_url = @request_url + "&q=feedname:" + URI.escape("\"" + feedname + "\"")
      end
    end

    if keyword != nil && keyword != "" then
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
        desc_style = "bs-callout bs-callout-default"
      when "dailytelegraph" then
        feedname = "England : The Daily Telegraph"
        label_style = "label label-default"
        desc_style = "bs-callout bs-callout-default"
      when "telegraph" then
        feedname = "England : The Daily Telegraph"
        label_style = "label label-default"
        desc_style = "bs-callout bs-callout-default"
      when "independent" then
        feedname = "England : The Independent"
        label_style = "label label-default"
        desc_style = "bs-callout bs-callout-default"
      when "Evening Standard" then
        feedname = "England : Evening Standard"
        label_style = "label label-default"
        desc_style = "bs-callout bs-callout-default"
      when "MARCA" then
        feedname = "Spain : MARCA"
        label_style = "label label-danger"
        desc_style = "bs-callout bs-callout-danger"
      when "mundo deportivo" then
        feedname = "Spain : El Mundo Deportivo"
        label_style = "label label-danger"
        desc_style = "bs-callout bs-callout-danger"
      when "spainsport" then
        feedname = "Spain : SPORT"
        label_style = "label label-danger"
        desc_style = "bs-callout bs-callout-danger"
      when "gazzetta dello sport" then
        feedname = "Italy : La Gazzetta dello Sport"
        label_style = "label label-success"
        desc_style = "bs-callout bs-callout-success"
      when "corrieredellosport" then
        feedname = "Italy : Corriere dello Sport"
        label_style = "label label-success"
        desc_style = "bs-callout bs-callout-success"
      when "tutto sport" then
        feedname = "Italy : Tuttosport"
        label_style = "label label-success"
        desc_style = "bs-callout bs-callout-success"
      when "build" then
        feedname = "Germany : Bild-Zeitung"
        label_style = "label label-warning"
        desc_style = "bs-callout bs-callout-warning"
      when "kicker" then
        feedname = "Germany : Kicker-Sportmagazin"
        label_style = "label label-warning"
        desc_style = "bs-callout bs-callout-warning"
      when "Lequipe" then
        feedname = "France : L'Equip"
        label_style = "label label-info"
        desc_style = "bs-callout bs-callout-info"
      when "Le Monde" then
        feedname = "France : Le Monde"
        label_style = "label label-info"
        desc_style = "bs-callout bs-callout-info"
      end


      result = {"article_id" => hit["_id"], "title" => title_en, "title_ja" => title_ja,
        "author" => hit["fields"]["author"],
        "published_date" => hit["fields"]["publishedDate"],
        "link" => hit["fields"]["link"], "feedname" => feedname,
        "label_style" => label_style, "japaneseDesc" => hit["fields"]["japaneseDesc"], "desc_style" => desc_style}
      @result_array.push(result)
    end


  end

  def search

    @search_feedname = params[:search_feedname]
    @keyword = params[:keyword]

    if @search_feedname != nil && @search_feedname != "" then
      logger.debug("@search_feedname :" + @search_feedname)
      case @search_feedname
      when "england" then
        @request_url = @request_url + "&q=feedname:" + URI.escape("dailymail dailytelegraph telegraph independent \"Evening Standard\"")
        @title_tag_value = "EnglandのサッカーニュースならOKfoot"
        @meta_description_value = "海外サッカーニュースを収集する日本最大級のサイトです。このページではEnglandのサッカーニュースを収集しています。"
      when "spain" then
        @request_url = @request_url + "&q=feedname:" + URI.escape("spainsport MARCA \"mundo deportivo\"")
        @title_tag_value = "SpainのサッカーニュースならOKfoot"
        @meta_description_value = "海外サッカーニュースを収集する日本最大級のサイトです。このページではSpainのサッカーニュースを収集しています。"
      when "germany" then
        @request_url = @request_url + "&q=feedname:" + URI.escape("build kicker")
        @title_tag_value = "GermanyのサッカーニュースならOKfoot"
        @meta_description_value = "海外サッカーニュースを収集する日本最大級のサイトです。このページではGermanyのサッカーニュースを収集しています。"
      when "italy" then
        @request_url = @request_url + "&q=feedname:" + URI.escape("\"gazzetta dello sport\" corrieredellosport \"tutto sport\"")
        @title_tag_value = "ItalyのサッカーニュースならOKfoot"
        @meta_description_value = "海外サッカーニュースを収集する日本最大級のサイトです。このページではItalyのサッカーニュースを収集しています。"
      when "france" then
        @request_url = @request_url + "&q=feedname:" + URI.escape("Lequipe \"Le Monde\"")
        @title_tag_value = "FranceのサッカーニュースならOKfoot"
        @meta_description_value = "海外サッカーニュースを収集する日本最大級のサイトです。このページではFranceのサッカーニュースを収集しています。"
      else
        @request_url = @request_url + "&q=feedname:" + URI.escape("\"" + @search_feedname + "\"")
        @title_tag_value = @search_feedname + "のサッカーニュースならOKfoot"
        @meta_description_value = "海外サッカーニュースを収集する日本最大級のサイトです。このページでは" + @search_feedname + "のサッカーニュースを収集しています。"
      end
    end

    if @keyword != nil && @keyword != "" then
      logger.debug("keyword :" + @keyword)
      @request_url = @request_url + "&q=title:" + URI.escape(@keyword)
      @title_tag_value = "OKfootでの検索結果（検索ワード：" + @keyword + "）"
      @meta_description_value = "海外サッカーニュースを収集する日本最大級のサイトです。このページでは検索結果を表示しています。"
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
        desc_style = "bs-callout bs-callout-default"
      when "dailytelegraph" then
        feedname = "England : The Daily Telegraph"
        label_style = "label label-default"
        desc_style = "bs-callout bs-callout-default"
      when "telegraph" then
        feedname = "England : The Daily Telegraph"
        label_style = "label label-default"
        desc_style = "bs-callout bs-callout-default"
      when "independent" then
        feedname = "England : The Independent"
        label_style = "label label-default"
        desc_style = "bs-callout bs-callout-default"
      when "Evening Standard" then
        feedname = "England : Evening Standard"
        label_style = "label label-default"
        desc_style = "bs-callout bs-callout-default"
      when "MARCA" then
        feedname = "Spain : MARCA"
        label_style = "label label-danger"
        desc_style = "bs-callout bs-callout-danger"
      when "mundo deportivo" then
        feedname = "Spain : El Mundo Deportivo"
        label_style = "label label-danger"
        desc_style = "bs-callout bs-callout-danger"
      when "spainsport" then
        feedname = "Spain : SPORT"
        label_style = "label label-danger"
        desc_style = "bs-callout bs-callout-danger"
      when "gazzetta dello sport" then
        feedname = "Italy : La Gazzetta dello Sport"
        label_style = "label label-success"
        desc_style = "bs-callout bs-callout-success"
      when "corrieredellosport" then
        feedname = "Italy : Corriere dello Sport"
        label_style = "label label-success"
        desc_style = "bs-callout bs-callout-success"
      when "tutto sport" then
        feedname = "Italy : Tuttosport"
        label_style = "label label-success"
        desc_style = "bs-callout bs-callout-success"
      when "build" then
        feedname = "Germany : Bild-Zeitung"
        label_style = "label label-warning"
        desc_style = "bs-callout bs-callout-warning"
      when "kicker" then
        feedname = "Germany : Kicker-Sportmagazin"
        label_style = "label label-warning"
        desc_style = "bs-callout bs-callout-warning"
      when "Lequipe" then
        feedname = "France : L'Equip"
        label_style = "label label-info"
        desc_style = "bs-callout bs-callout-info"
      when "Le Monde" then
        feedname = "France : Le Monde"
        label_style = "label label-info"
        desc_style = "bs-callout bs-callout-info"
      end


      result = {"article_id" => hit["_id"], "title" => title_en, "title_ja" => title_ja,
        "author" => hit["fields"]["author"],
        "published_date" => hit["fields"]["publishedDate"],
        "link" => hit["fields"]["link"], "feedname" => feedname,
        "label_style" => label_style, "japaneseDesc" => hit["fields"]["japaneseDesc"], "desc_style" => desc_style}
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
      # url = "http://54.199.172.16:9200/news/page/" + article_id + "?pretty&fields=link,title,description&sort=publishedDate"
      url = "http://localhost:9200/news/page/" + article_id + "?pretty&fields=link,title,description&sort=publishedDate"
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
