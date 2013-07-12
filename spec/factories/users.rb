# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :user do
    sequence(:email) { |n| "user#{n}@example.com" }
    password 'password'

    factory :user_confirmed do
      confirmed_at Date.today

      factory :admin do
        admin true
      end
    end
  end
end
