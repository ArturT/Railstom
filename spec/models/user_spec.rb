require 'spec_helper'

describe User do
  let(:user) { create(:user) }

  subject { build(:user_unconfirmed) }

  it { should be_valid }
  it { should have_many(:authentications) }

  its(:admin) { should be_false }
  its(:blocked) { should be_false }
  its(:enabled_newsletter) { should be_true }
  its(:preferred_language) { should eql I18n.default_locale }

  describe '.build_with_omniauth' do
    let(:email) { 'email@example.com' }
    let(:avatar) { 'https://graph.facebook.com/username/picture?type=large' }
    let(:auth) do
      {
        'info' => {
          'email' => email,
          'avatar' => avatar
        }
      }
    end

    subject { User.build_with_omniauth(auth) }

    it { should be_new_record }
    its(:email) { should eql(email) }
    its(:password) { should_not be_nil }
    its(:confirmed_at) { should_not be_nil }
    # FIXME find way how to test it
    # its(:remote_avatar_url) { should eql(avatar) }
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

  describe 'private #set_preferred_language' do
    before do
      @user = build(:user, preferred_language: '')
      expect(@user.preferred_language).to eql ''
    end

    it 'set preferred language if was blank' do
      @user.valid?
      expect(@user.preferred_language).to eql I18n.locale
    end

    it "don't change preferred language if was set" do
      @user.preferred_language = :xy
      @user.valid?
      expect(@user.preferred_language).to eql :xy
    end
  end

  describe 'scopes' do
    before do
      @admin = create(:admin)
      @user = create(:user)
      @user_blocked = create(:user, blocked: true)
      @user_with_disabled_newsletter = create(:user, enabled_newsletter: false)
    end

    describe '.admins' do
      it { expect(User.admins).to match_array([@admin]) }
    end

    describe '.active' do
      it { expect(User.active).to match_array([@admin, @user, @user_with_disabled_newsletter]) }
    end

    describe '.blocked' do
      it { expect(User.blocked).to match_array([@user_blocked]) }
    end

    describe '.with_enabled_newsletter' do
      it { expect(User.with_enabled_newsletter).to match_array([@admin, @user, @user_blocked]) }
    end

    describe '.with_disabled_newsletter' do
      it { expect(User.with_disabled_newsletter).to match_array([@user_with_disabled_newsletter]) }
    end
  end
end
