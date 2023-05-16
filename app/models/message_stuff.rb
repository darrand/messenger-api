class MessageStuff < ApplicationRecord
  belongs_to :conversation
  belongs_to :sender, class_name: "User"
end
