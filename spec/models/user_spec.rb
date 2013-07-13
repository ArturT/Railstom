require 'spec_helper'

describe User do
  let(:user) { create(:user) }

  subject { build(:user_unconfirmed) }

  it { should be_valid }
  it { should have_many(:authentications) }

  its(:admin) { should be_false }

  describe '.build_with_omniauth' do
    let(:email) { 'email@example.com' }
    let(:auth) do
      {
        'info' => {
          'email' => email
        }
      }
    end

    subject { User.build_with_omniauth(auth) }

    it { should be_new_record }
    its(:email) { should eql(email) }
    its(:password) { should_not be_nil }
    its(:confirmed_at) { should_not be_nil }
  end

  describe '#confirm' do
    before do
      subject.confirmed_at = nil
      subject.confirmation_token = 'token'

      subject.confirm
    end

    its(:confirmed_at) { should_not be_nil }
    its(:confirmation_token) { should be_nil }
  end

  describe '#generate_password' do
    before do
      subject.password = nil

      subject.generate_password
    end

    its(:password) { should_not be_nil }
  end

  describe '#has_provider?' do
    subject { create(:user_unconfirmed) }

    context 'when has facebook provider' do
      before do
        create(:authentication_facebook, user: subject)
      end

      it 'returns true' do
        expect(subject.has_provider?(:facebook)).to be_true
      end
    end

    context 'when has not facebook provider' do
      it 'returns false' do
        expect(subject.has_provider?(:facebook)).to be_false
      end
    end
  end

  describe '#destroy' do
    subject { user }

    before do
      create(:authentication_facebook, user: subject)
    end

    it 'destroyed user should not exist in db' do
      subject.destroy
      expect(subject).not_to exist_in_database
    end
  end

  describe '#provider_names' do
    context 'password_changed is true' do
      it { expect(user.password_changed).to be_true }

      context 'user has provider' do
        it 'email' do
          expect(user.provider_names).to eql ['email']
        end

        it 'facebook' do
          create(:authentication_facebook, user: user)

          expect(user.provider_names).to eql ['email', 'facebook']
        end
      end
    end

    context 'password_changed is false' do
      before { user.password_changed = false }

      it { expect(user.password_changed).to be_false }

      context 'user has not provider' do
        it 'email' do
          expect(user.provider_names).to eql []
        end

        it 'facebook' do
          create(:authentication_facebook, user: user)

          expect(user.provider_names).to eql ['facebook']
        end
      end
    end
  end
end
