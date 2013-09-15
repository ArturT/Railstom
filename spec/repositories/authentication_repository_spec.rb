require 'spec_helper'

describe AuthenticationRepository do
  let(:db_authentication) { Authentication }

  subject { isolate(AuthenticationRepository) }

  describe '#build' do
    its(:build) { should be_a(Authentication)}
    its(:build) { should_not be_nil }
  end

  describe '#find_by_provider_and_uid' do
    let(:provider) { 'facebook' }
    let(:uid) { 'uid_facebook' }
    let(:provider_data) do
      { provider: provider, uid: uid }
    end

    it 'finds particular authentication' do
      expect(db_authentication).to receive(:find_by).with(provider_data)
      subject.find_by_provider_and_uid(provider, uid)
    end
  end
end

