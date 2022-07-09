FactoryBot.define do
  factory :user do
    email { Faker::Internet.unique.safe_email }
    password { Faker::Internet.password }
    name { Faker::Name.name }
    admin { false }
  end
end