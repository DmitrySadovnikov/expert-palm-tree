FactoryBot.define do
  factory :stock do
    bearer
    sequence(:name) { |n| "stock_#{n}" }
  end
end
