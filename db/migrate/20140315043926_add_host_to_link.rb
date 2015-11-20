class AddHostToLink < ActiveRecord::Migration
  def change
    add_column :links, :host, :string
  end
end
