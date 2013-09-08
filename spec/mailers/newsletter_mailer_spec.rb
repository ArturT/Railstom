require "spec_helper"

describe NewsletterMailer do
  before do
    ActionMailer::Base.deliveries.clear
  end

  describe '.newsletter' do
    let(:user) { build(:user) }
    let(:newsletter) { build(:newsletter) }

    subject { ActionMailer::Base.deliveries.last }

    before do
      NewsletterMailer.newsletter(user, newsletter.subject, newsletter.body).deliver
    end

    its(:to) { should include user.email }
    its(:subject) { should eql newsletter.subject }
    its(:body) { should include newsletter.body }
  end
end
