class CreateConversations < ActiveRecord::Migration[6.1]
  def change
    create_table :conversations do |t|
      t.integer :user1_unread_count, :default => 0
      t.integer :user2_unread_count, :default => 0
      t.references :user1, null: false
      t.references :user2, null: false

      t.timestamps
    end 
    add_foreign_key :conversations, :users, column: :user1_id
    add_foreign_key :conversations, :users, column: :user2_id
  end
end
