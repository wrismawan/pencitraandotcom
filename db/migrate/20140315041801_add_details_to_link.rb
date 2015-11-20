class AddDetailsToLink < ActiveRecord::Migration
  def change
    add_column :links, :title, :string
    add_column :links, :description, :text
    add_column :links, :image_url, :text
  end
end
