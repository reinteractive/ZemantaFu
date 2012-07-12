class Zemanta::Image < ActiveRecord::Base
  self.table_name = 'zemanta_images'
  belongs_to :zemanta_search, :class_name => "::ZemantaSearch"
  
  def self.save_to_database(zemanta_search_id, image)
    unless image.nil?
      ZemantaImage.create!(:zemanta_search_id => zemanta_search_id,
            :description => image.description,
            :attribution => image.attribution, 
            :license => image.license,
            :source_url => image.source_url,
            :confidence => image.confidence,
            :url_s => image.url_s,
            :url_s_w => image.url_s_w.to_i,
            :url_s_h => image.url_s_h.to_i,
            :url_m => image.url_m,
            :url_m_w => image.url_m_w.to_i,
            :url_m_h => image.url_m_h.to_i,
            :url_l => image.url_l,
            :url_l_w => image.url_l_w.to_i,
            :url_l_h => image.url_l_h.to_i
          )
    end
  end
  
end