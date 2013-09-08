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
    describe '#send_newsletter' do
      context 'when started_at is set' do
        let(:started_at) { 1.minutes.from_now }

        before do
          subject.stub(:started_at).and_return(started_at)
        end

        it 'calls NewsletterWorker.perform_at' do
          expect(NewsletterWorker).to receive(:perform_at).with(started_at, subject.id)
          subject.send(:send_newsletter)
        end
      end

      context 'when started_at is not set' do
        before do
          subject.stub(:started_at).and_return(nil)
        end

        it 'calls NewsletterWorker.perform_async' do
          expect(NewsletterWorker).to receive(:perform_async).with(subject.id)
          subject.send(:send_newsletter)
        end
      end
    end

    describe '#resume_newsletter' do
      context 'when stopped changed' do
        before do
          subject.stub(:stopped_changed?).and_return(true)
        end

        context 'when stopped is true' do
          before do
            subject.stub(:stopped).and_return(true)
          end

          it "doesn't call NewsletterWorker.perform_async" do
            expect(NewsletterWorker).not_to receive(:perform_async).with(subject.id)
            subject.send(:resume_newsletter)
          end
        end

        context 'when stopped is false' do
          before do
            subject.stub(:stopped).and_return(false)
          end

          it 'calls NewsletterWorker.perform_async' do
            expect(NewsletterWorker).to receive(:perform_async).with(subject.id)
            subject.send(:resume_newsletter)
          end
        end
      end

      context "when stopped didn't change" do
        before do
          subject.stub(:stopped_changed?).and_return(false)
        end

        it "doesn't call NewsletterWorker.perform_async" do
          expect(NewsletterWorker).not_to receive(:perform_async).with(subject.id)
          subject.send(:resume_newsletter)
        end
      end
    end

    describe '#send_preview_email' do
      before do
        newsletter.preview_email = email
        newsletter.valid?
      end

      context 'when preview email is blank' do
        let(:email) { '' }

        it 'has no error on preview_email' do
          expect(newsletter.errors).to have(0).error_on(:preview_email)
        end
      end

      context 'when preview email is not blank', :sidekiq_inline do
        let(:email) { 'email@example.com' }
        let(:mail) { ActionMailer::Base.deliveries.last }

        it 'has error on preview email' do
          expect(newsletter.errors).to have(1).error_on(:preview_email)
        end

        describe 'delivers newsletter to preview email' do
          subject { mail }

          its(:to) { should include email }
          its(:subject) { should eql newsletter.subject }
          its(:body) { should include newsletter.body }
        end
      end
    end
  end
end
