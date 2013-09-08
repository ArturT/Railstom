require 'spec_helper'

describe Newsletter do
  let(:newsletter) { build(:newsletter) }

  subject { newsletter }

  it { should be_valid }
  it { should validate_presence_of(:subject) }
  it { should validate_presence_of(:body) }
  its(:enabled_force) { should be_false }
  its(:stopped) { should be_false }
  its(:last_user_id) { should eql 0 }
  its(:preview_email) { should be_blank }

  describe 'private methods' do
    describe '#send_preview_email' do
      before do
        subject.preview_email = email
        subject.valid?
      end

      context 'when preview email is blank' do
        let(:email) { '' }

        it 'has no error on preview_email' do
          expect(subject.errors).to have(0).error_on(:preview_email)
        end
      end

      context 'when preview email is not blank', :sidekiq_inline do
        let(:email) { 'email@example.com' }
        let(:mail) { ActionMailer::Base.deliveries.last }

        it 'has error on preview email' do
          expect(subject.errors).to have(1).error_on(:preview_email)
        end

        describe 'delivers newsletter to preview email' do
          its(:to) { expect(mail.to).to include email }
          its(:subject) { expect(mail.subject).to eql newsletter.subject }
          its(:body) { expect(mail.body.to_s).to include newsletter.body }
        end
      end
    end
  end
end
