class AddTokohToLink < ActiveRecord::Migration
  def change
    add_column :links, :tokoh, :string
  end
end
