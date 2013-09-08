# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :newsletter do
    title "MyString"
    body "MyText"
    enabled_force false
    stopped false
    last_user_id 1
    started_at "2013-09-08 12:13:54"
    finished_at "2013-09-08 12:13:54"
  end
end
