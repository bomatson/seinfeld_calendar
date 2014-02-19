# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :user do
    sequence(:github_username) { |n| "#{Faker::Internet.user_name}_#{n}" }
  end
end
