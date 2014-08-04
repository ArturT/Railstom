require 'spec_helper'

describe OmniauthCallbacksController do
  let(:email) { 'email@example.com' }

  before do
    @request.env['devise.mapping'] = Devise.mappings[:user]
  end

  describe '#new' do
    let(:provider) { 'facebook' }

    before do
      post :new, locale: I18n.locale, provider: provider, email: email
    end

    it { should redirect_to user_omniauth_authorize_path(provider) }
    it { expect(session[:email]).to eql email }
  end

  describe '#facebook' do
    before do
      @request.env['omniauth.auth'] = {
        'provider' => 'facebook',
        'uid' => 'uid_facebook',
        'info' => {
          'email' => email
        }
      }
    end

    subject { response }

    context 'user is signed in' do
      let!(:user) { create(:user) }

      context 'authentication is linked to user' do
        let!(:authentication_facebook) { create(:authentication_facebook, user: user) }

        before do
          sign_in user
          get :facebook
        end

        it { should redirect_to(root_path) }
        its('flash notice') { expect(flash[:notice]).to eql I18n.t('controllers.omniauth_callbacks.flash.already_linked_account') }
      end

      context 'authentication is not linked to user' do
        before do
          sign_in user
          get :facebook
        end

        it { should redirect_to(root_path) }
        its('flash notice') { expect(flash[:notice]).to eql I18n.t('controllers.omniauth_callbacks.flash.successfully_linked_account') }
      end

      context 'authentication is linked to other user' do
        let!(:other_user) { create(:user) }
        let!(:authentication_facebook) { create(:authentication_facebook, user: other_user) }

        before do
          sign_in user
          get :facebook
        end

        it { should redirect_to(root_path) }
        its('flash notice') { expect(flash[:notice]).to eql I18n.t('controllers.omniauth_callbacks.flash.provider_linked_with_other_account_html', provider: 'facebook') }
      end
    end

    context 'user is not signed in' do
      context 'authentication is linked to user' do
        let!(:user) { create(:user) }
        let!(:authentication_facebook) { create(:authentication_facebook, user: user) }

        before do
          get :facebook
        end

        it { should redirect_to(root_path) }
        its('flash notice') { expect(flash[:notice]).to eql I18n.t('devise.omniauth_callbacks.success', kind: 'Facebook') }
      end

      context 'authentication is not linked to user' do
        context "user with provider email exists in db" do
          let!(:user) { create(:user, email: email) }

          before do
            get :facebook
          end

          it { should redirect_to(new_user_session_path) }
          its('flash notice') { expect(flash[:notice]).to eql I18n.t('controllers.omniauth_callbacks.flash.sign_in_before_link_account_html', email: email, provider: 'facebook') }
        end

        context "user with provider email doesn't exist in db" do
          let!(:user) { create(:user) }

          context 'a new user is valid' do
            before do
              get :facebook
            end

            it { should redirect_to(root_path) }
            its('flash notice') { expect(flash[:notice]).to eql I18n.t('devise.omniauth_callbacks.success', kind: 'Facebook') }
          end

          context 'a new user has missing email' do
            context 'when email provided in session' do
              before do
                session[:email] = email
                @request.env['omniauth.auth'] = {
                  'provider' => 'facebook',
                  'uid' => 'uid_facebook',
                }
                get :facebook
              end

              it { should redirect_to(root_path) }
              its('flash notice') { expect(flash[:notice]).to eql I18n.t('devise.omniauth_callbacks.success', kind: 'Facebook') }
            end

            context 'when email not provided in session' do
              before do
                @request.env['omniauth.auth'] = {
                  'provider' => 'facebook',
                  'uid' => 'uid_facebook',
                }
                get :facebook
              end

              it { should render_template(:ask_for_email) }
            end
          end

          context 'a new user is not valid' do
            before do
              @request.env['omniauth.auth'] = {} # invalid data from provider
              get :facebook
            end

            it { should redirect_to(new_user_registration_path) }
            its('flash notice') { expect(flash[:notice]).to eql I18n.t('controllers.omniauth_callbacks.flash.invalid_provider') }
          end
        end
      end
    end
  end
end
