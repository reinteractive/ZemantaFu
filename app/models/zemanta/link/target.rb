class Zemanta::Link::Target < ActiveRecord::Base
  self.table_name = 'zemanta_link_targets'
  belongs_to :zemanta_link, :class_name => "::ZemantaLink"
  
  def self.save_to_database(zemanta_link_id, target)
    unless target.nil?
      ZemantaLinkTarget.create!(:zemanta_link_id => zemanta_link_id,
            :url => target.url,
            :type => target.type,
            :title => target.title
            )
    end
  end
  
end