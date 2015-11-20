class CreateSenders < ActiveRecord::Migration
  def change
    create_table :senders do |t|
      t.string :image_url
      t.string :username

      t.timestamps
    end
  end
end
