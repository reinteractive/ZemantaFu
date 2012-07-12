class Zemanta::Link < ActiveRecord::Base
  self.table_name = 'zemanta_links'
  belongs_to  :zemanta_search, :class_name => "::ZemantaSearch"
  has_many    :zemanta_link_targets, :class_name => "::ZemantaLinkTarget", :foreign_key => "zemanta_link_id"
  
  def self.save_to_database(zemanta_search_id, link)
    unless link.nil?
      zlink = ZemantaLink.create!(:zemanta_search_id => zemanta_search_id,
                    :confidence => link.confidence.to_f,
                    :anchor => link.anchor
                    )
      link.targets.each do |target|
        ZemantaLinkTarget.save_to_database(zlink.id, target)
      end
    end
  end
  
end