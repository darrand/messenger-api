FactoryBot.define do
    factory :message do
        message "Test"
        sender {association :user}
        conversation {association :conversation}
    end
  end
  