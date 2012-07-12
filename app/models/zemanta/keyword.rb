class Zemanta::Keyword < ActiveRecord::Base
  self.table_name = 'zemanta_keywords'
  belongs_to :zemanta_search, :class_name => "::ZemantaSearch"
  
  def self.save_to_database(zemanta_search_id, keyword)
    unless keyword.nil?
      ZemantaKeyword.create!(:zemanta_search_id => zemanta_search_id,
          :confidence => keyword.confidence.to_f,
          :name => keyword.name,
          :scheme => keyword.scheme
          )
    end
  end
  
end