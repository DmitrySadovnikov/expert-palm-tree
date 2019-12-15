FactoryBot.define do
  factory :bearer do
    sequence(:name) { |n| "bearer_#{n}" }
  end
end
