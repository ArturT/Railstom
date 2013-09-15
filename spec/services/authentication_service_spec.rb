require 'spec_helper'

describe AuthenticationService do
  let(:authentication_repository) { double }
  let(:provider) { 'provider' }
  let(:uid) { 'uid_provider' }
  let(:omniauth_hash) do
    {
      'provider' => provider,
      'uid' => uid
    }
  end
  let(:current_user) { double }

  subject { isolate(AuthenticationService) }

  describe '#find_or_build' do
    let(:result_find_by_provider_and_uid) { double }
    let(:result_build_with_omniauth) { double }

    before do
      authentication_repository.stub(:find_by_provider_and_uid).with(provider, uid).and_return(result_find_by_provider_and_uid)
      subject.stub(:build_with_omniauth).and_return(result_build_with_omniauth)
      subject.find_or_build
    end

    context 'when authentication exists in db' do
      it 'finds authentication with omniauth' do
        expect(authentication_repository).to have_received(:find_by_provider_and_uid).with(provider, uid)
      end

      it 'returns result of find_with_omniauth' do
        expect(subject.find_or_build).to eql result_find_by_provider_and_uid
      end
    end

    context "when authentication doesn't exist in db" do
      let(:result_find_by_provider_and_uid) { nil }

      it 'builds authentication with omniauth' do
        expect(authentication_repository).to have_received(:find_by_provider_and_uid).with(provider, uid)
        expect(subject).to have_received(:build_with_omniauth)
      end

      it 'returns result of build_with_omniauth' do
        expect(subject.find_or_build).to eql result_build_with_omniauth
      end
    end
  end
end
