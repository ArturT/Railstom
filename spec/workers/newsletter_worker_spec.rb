require 'spec_helper'

describe NewsletterWorker do
  it { should be_processed_in :newsletter }
  it { should be_retryable true }
  it { should_not be_unique }
end
