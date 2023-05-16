class CreateMessageStuffs < ActiveRecord::Migration[6.1]
  def change
    create_table :message_stuffs do |t|
      t.string :message
      t.references :sender, null: false
      t.references :conversation, null: false

      t.timestamps
    end
    add_foreign_key :message_stuffs, :users, column: :sender_id
    add_foreign_key :message_stuffs, :conversations, column: :conversation_id	
  end
end
