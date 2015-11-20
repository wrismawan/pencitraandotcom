class Comment < ActiveRecord::Base
  belongs_to :link
  attr_accessible :content, :image_url, :link_id, :sender
end
