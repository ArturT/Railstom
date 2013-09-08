class Newsletter < ActiveRecord::Base
  validates :subject, :body, presence: true
end
