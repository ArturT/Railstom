# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :user do
    sequence(:email) { |n| "user#{n}@example.com" }
    password 'password'
    confirmed_at Date.today

    factory :user_unconfirmed do
      confirmed_at nil
    end

    factory :admin do
      admin true
    end
  end
end
