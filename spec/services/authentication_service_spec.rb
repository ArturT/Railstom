require 'spec_helper'

describe AuthenticationService do
  let(:authentication_repository) { double }
  let(:provider) { 'provider' }
  let(:uid) { 123 }
  let(:omniauth_hash) do
    {
      'provider' => provider,
      'uid' => uid
    }
  end
  let(:authentication) { mock_model(Authentication) }
  let(:current_user) { mock_model(User) }
  let(:user) { mock_model(User) }

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

  describe '#build_with_omniauth' do
    it 'returns a new authentication with proper attributes' do
      expect(authentication_repository).to receive(:build).with({
        provider: provider,
        uid: uid.to_s
      })
      subject.build_with_omniauth
    end
  end

  describe '#user_linked?' do
    context 'when checking if given user is linked' do
      context 'when user is linked' do
        before do
          authentication.stub(:user).and_return(user)
        end

        it 'returns true' do
          expect(subject.user_linked?(authentication, user)).to be true
        end
      end

      context 'when user is not linked' do
        before do
          authentication.stub(:user).and_return(nil)
        end

        it 'returns false' do
          expect(subject.user_linked?(authentication, user)).to be false
        end
      end
    end

    context 'when checking if current user is linked' do
      context 'when current user is linked' do
        before do
          authentication.stub(:user).and_return(current_user)
        end

        it 'returns true' do
          expect(subject.user_linked?(authentication)).to be true
        end
      end

      context 'when current user is not linked' do
        before do
          authentication.stub(:user).and_return(nil)
        end

        it 'returns false' do
          expect(subject.user_linked?(authentication)).to be false
        end
      end
    end
  end

  describe '#user_link_with' do
    context 'when link given user' do
      it 'updates attribute user for authentication with given user' do
        expect(authentication).to receive(:update_attribute).with(:user, user)
        subject.user_link_with(authentication, user)
      end
    end

    context 'when link current user' do
      it 'updates attribute user for authentication with current user' do
        expect(authentication).to receive(:update_attribute).with(:user, current_user)
        subject.user_link_with(authentication)
      end
    end
  end

  describe '#has_user?' do
    context 'when authentication is linked with user' do
      it 'returns true' do
        authentication.stub(:user).and_return(user)
        expect(subject.has_user?(authentication)).to be true
      end
    end

    context 'when authentication is not linked with user' do
      it 'returns false' do
        authentication.stub(:user).and_return(nil)
        expect(subject.has_user?(authentication)).to be false

        authentication.stub(:user).and_return('')
        expect(subject.has_user?(authentication)).to be false
      end
    end
  end
end
