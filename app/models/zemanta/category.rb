class Zemanta::Category < ActiveRecord::Base
  self.table_name = 'zemanta_categories'
  belongs_to :zemanta_category, :class_name => "::ZemantaSearch"

  def self.save_to_database(zemanta_search_id, category)
    unless category.nil?
      ZemantaCategory.create!(:zemanta_search_id => zemanta_search_id,
            :confidence => category.confidence.to_f,
            :categorization => category.categorization,
            :name => category.name)
    end
  end
  
end