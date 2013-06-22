FactoryGirl.define do
  factory :authentication do
    user
    provider "provider"
    uid "uid"

    factory :authentication_facebook do
      provider 'facebook'
      uid 'uid_facebook'
    end

    factory :authentication_google do
      provider 'google'
      uid 'uid_google'
    end
  end
end
