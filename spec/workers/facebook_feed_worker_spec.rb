require 'spec_helper'

describe FacebookFeedWorker do
  it { should be_processed_in :default }
  it { should be_retryable true }
  it { should_not be_unique }
end
