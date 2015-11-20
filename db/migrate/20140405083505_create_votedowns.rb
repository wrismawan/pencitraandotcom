class CreateVotedowns < ActiveRecord::Migration
  def change
    create_table :votedowns do |t|
      t.integer :link_id
      t.integer :user_id

      t.timestamps
    end
  end
end
