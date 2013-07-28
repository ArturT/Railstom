require 'highline/import'
require "#{Rails.root}/lib/ext/tasks_helper"

include TasksHelper

namespace :db do

  namespace :populate do
    task users: :environment do
      message('Create users')
      limit = ask('How many users create?', Integer)
      default_password = ask('Enter password for each user or press enter to use default:') { |q| q.default = '12345678' }
      limit.times do |n|
        user = User.new(
          email: rand(2) == 0 ? Faker::Internet.free_email : Faker::Internet.email,
          password: default_password
        )
        user.confirm
        user.save!

        puts user.email
      end
    end
  end

end
