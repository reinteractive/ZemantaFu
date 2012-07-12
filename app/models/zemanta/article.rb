class Zemanta::Article < ActiveRecord::Base
  self.table_name = 'zemanta_articles'
  belongs_to :zemanta_search, :class_name => "::ZemantaSearch"
  
  def self.save_to_database(zemanta_search_id, article)
    unless article.nil?
      ZemantaArticle.create!(:zemanta_search_id => zemanta_search_id, 
            :url => article.url,
            :confidence => article.confidence.to_f,
            :published_datetime => DateTime.parse(article.published_datetime),
            :title => article.title,
            :zemified => article.zemified.to_i
            )
    end
  end
  
end