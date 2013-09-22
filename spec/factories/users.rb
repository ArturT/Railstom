# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :user do
    sequence(:nickname) { |n| "nickname#{n}" }
    sequence(:email) { |n| "user#{n}@example.com" }
    password 'password'
    preferred_language I18n.default_locale
    confirmed_at Date.today

    factory :user_unconfirmed do
      confirmed_at nil
    end

    factory :admin do
      admin true
    end
  end
end
