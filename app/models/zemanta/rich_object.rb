class Zemanta::RichObject < ActiveRecord::Base
  self.table_name = 'zemanta_rich_objects'
  belongs_to :zemanta_search, :class_name => "::ZemantaSearch"
  
  def self.save_to_database(zemanta_search_id, rich_object)
    unless rich_object.nil?
      ZemantaRichObject.create!(:zemanta_search_id => zemanta_search_id,
              :title  => rich_object.title,
              :thumbnail_url => rich_object.thumbnail_url,
              :thumbnail_width => rich_object.thumbnail_width.to_i,
              :thumbnail_height => rich_object.thumbnail_height.to_i,
              :url => rich_object.url,
              :height => rich_object.height.to_i,
              :width => rich_object.width.to_i,
              :html => rich_object.html
              )
    end
  end
  
end