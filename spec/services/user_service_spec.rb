require 'spec_helper'

describe UserService do
  let(:user_repository) { double }
  let(:nickname) { 'NickName' }
  let(:password) { 'UserPassword' }
  let(:email) { 'railstom@example.com' }
  let(:avatar) { 'https://graph.facebook.com/username/picture?type=large' }
  let(:omniauth_hash) do
    {
      'info' => {
        'nickname' => nickname,
        'email' => email,
        'image' => avatar
      }
    }
  end
  let(:generator_service) do
    double(:generator_service, password: password, nickname_with_omniauth: nickname)
  end

  subject { isolate(UserService) }

  describe '#build_with_omniauth' do
    it 'returns a new user with proper attributes' do
      Timecop.freeze do
        expect(generator_service).to receive(:password).with(8).and_return(password)
        expect(user_repository).to receive(:build).with({
          email: email,
          remote_avatar_url: avatar,
          password: password,
          confirmation_token: nil,
          confirmed_at: Time.now.utc
        })
        subject.build_with_omniauth
      end
    end
  end
end
