class CreateComments < ActiveRecord::Migration
  def change
    create_table :comments do |t|
      t.text :content
      t.integer :link_id
      t.string :sender
      t.string :image_url

      t.timestamps
    end
  end
end
