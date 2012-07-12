class Zemanta::Search < ActiveRecord::Base
  self.table_name = 'zemanta_searches'
  has_many :zemanta_articles, :dependent => :destroy, :class_name => "::ZemantaArticle", :foreign_key => "zemanta_search_id"
  has_many :zemanta_keywords, :dependent => :destroy, :class_name => "::ZemantaKeyword", :foreign_key => "zemanta_search_id"
  has_many :zemanta_links, :dependent => :destroy, :class_name => "::ZemantaLink", :foreign_key => "zemanta_search_id"
  has_many :zemanta_categories, :dependent => :destroy, :class_name => "::ZemantaCategory", :foreign_key => "zemanta_search_id"
  has_many :zemanta_images, :dependent => :destroy, :class_name => "::ZemantaImage", :foreign_key => "zemanta_search_id"
  has_many :zemanta_rich_objects, :dependent => :destroy, :class_name => "::ZemantaRichObject", :foreign_key => "zemanta_search_id"
  
  # Saves results from zemanta search to database
  # Options:
  #   :exclude_tables => [:table_name]   -  example :exclude_tables => [:zemanta_articles] - would not save the results of articles
  def self.save_to_database(search_text, zemanta_search_result, options = {})
    res = zemanta_search_result
    options[:exclude_tables] ||= []
    zemanta_search = ZemantaSearch.create!(:search_text => search_text, :status => res.status, :rid => res.rid, :signature => res.signature)
    
    unless options[:exclude_tables].include?(:zemanta_articles)
      res.articles.each do |article|
        ZemantaArticle.save_to_database(zemanta_search.id, article)
      end
    end
    
    unless options[:exclude_tables].include?(:zemanta_categories)
      res.categories.each do |category|
        ZemantaCategory.save_to_database(zemanta_search.id, category)
      end
    end
    
    unless options[:exclude_tables].include?(:zemanta_images)
      res.images.each do |image|
        ZemantaImage.save_to_database(zemanta_search.id, image)
      end
    end
    
    unless options[:exclude_tables].include?(:zemanta_keywords)
      res.keywords.each do |keyword|
        ZemantaKeyword.save_to_database(zemanta_search.id, keyword)
      end
    end
    
    unless options[:exclude_tables].include?(:zemanta_links)
      res.markup.links.each do |link|
        ZemantaLink.save_to_database(zemanta_search.id, link)
      end
    end
    
    unless options[:exclude_tables].include?(:zemanta_rich_objects)
      res.rich_objects.each do |rich_object|
        ZemantaRichObject.save_to_database(zemanta_search.id, rich_object)
      end
    end
    zemanta_search.reload
    return zemanta_search
  end
  
end