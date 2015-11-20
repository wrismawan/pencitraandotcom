class AddVerifiedToLink < ActiveRecord::Migration
  def change
    add_column :links, :verified, :boolean, :default => false
  end
end
