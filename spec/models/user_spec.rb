require 'spec_helper'

describe User do
  subject { build(:user) }

  it { should be_valid }
  it { should have_many(:authentications) }

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
    subject { create(:user) }

    context 'when has facebook provider' do
      before do
        create(:authentication_facebook, user: subject)
      end

      it 'should return true' do
        expect(subject.has_provider?(:facebook)).to be_true
      end
    end

    context 'when has not facebook provider' do
      it 'should return false' do
        expect(subject.has_provider?(:facebook)).to be_false
      end
    end
  end

  describe '#destroy' do
    subject { create(:user) }

    before do
      create(:authentication_facebook, user: subject)
    end

    it 'destroyed user should not exist in db' do
      subject.destroy
      subject.should_not exist_in_database
    end
  end
end
