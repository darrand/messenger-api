FactoryBot.define do
    factory :conversation do
        user1_unread_count {0}
        user2_unread_count {0}
        user1 {association :user}
        user2 {association :user}
    end
  end
  