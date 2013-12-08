require 'hpricot'
require "open-uri"
require 'extractcontent'
require 'translation'

class ArticlesController < ApplicationController
  def show
    article_id = params[:id]
    logger.debug("article_id : " + article_id)

    # DBを検索
    article = Article.find_by article_id: article_id

    if article == nil then
      # データが存在しない場合はelasticsearchからのデータを翻訳してDBに登録
      logger.debug("article not found.")

      # elasticsearchからデータを取得
      url = "http://59.106.182.98:9200/news/page/4719c4f5-0200-3da3-bd35-c393c168cb16?pretty&fields=link&sort=publishedDate"
      article = open(url)
      json_object = JSON.load(article)
      link = json_object["fields"]["link"]
      logger.debug("link :" + link)

      doc = Hpricot(open(link).read)
      logger.debug("doc :" + doc.to_html)
      @body_en, title = ExtractContent.analyse(doc.to_html)
      hoge = Translation.new()
      @body_ja = hoge.trans(@body_en)
      # title_ja = hoge.trans(title)

    else
      # データが存在すれば返却
      logger.debug("article found.")

    end

  end
end
