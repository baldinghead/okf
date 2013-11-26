class CreateArticles < ActiveRecord::Migration
  def change
    create_table :articles do |t|
      t.string :aiticle_id
      t.string :title_en_auto
      t.string :title_ja_auto
      t.text :content_en_auto
      t.text :content_ja_auto
      t.string :title_en_hand
      t.string :title_ja_hand
      t.text :content_en_hand
      t.text :content_ja_hand
      t.text :author
      t.timestamp :written_date
      t.string :link
      t.string :country_cd
      t.string :label_title

      t.timestamps
    end
  end
end
