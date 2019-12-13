FactoryBot.define do
  factory :stock do
    bearer
    name { Faker::Lorem.word }
  end
end
