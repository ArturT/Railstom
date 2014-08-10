require 'spec_helper'

describe NewsletterWorker do
  it { should be_processed_in :newsletter }
  it { should be_retryable true }
  it { should_not be_unique }

  describe '#perform' do
    let(:newsletter) { mock_model(Newsletter) }
    let(:newsletter_service) { double(NewsletterService) }
    let(:interval) { NewsletterWorker::INTERVAL.seconds.from_now }

    before do
      allow(subject).to receive(:interval_seconds_from_now) { interval }

      expect(NewsletterService).to receive(:new).with(newsletter.id, NewsletterWorker::RECIPIENTS_LIMIT).and_return(newsletter_service)
      expect(newsletter_service).to receive(:run).and_return(run_return)
    end

    context 'when newsletter should continue sending' do
      let(:run_return) { :continue }

      it 'calls NewsletterWorker with perform_at' do
        expect(NewsletterWorker).to receive(:perform_at).with(interval, newsletter.id)
        subject.perform(newsletter.id)
      end
    end

    context 'when newsletter should not continue sending' do
      let(:run_return) { nil }

      it "doesn't calls NewsletterWorker with perform_at" do
        expect(NewsletterWorker).not_to receive(:perform_at).with(interval, newsletter.id)
        subject.perform(newsletter.id)
      end
    end
  end
end
