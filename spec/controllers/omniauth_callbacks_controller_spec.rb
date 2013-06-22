require 'spec_helper'

describe OmniauthCallbacksController do
  before do
    @request.env['devise.mapping'] = Devise.mappings[:user]
  end

  describe '#facebook' do
    before do
      @request.env['omniauth.auth'] = {
        'provider' => 'facebook',
        'uid' => 'uid_facebook',
        'info' => {
          'email' => 'email@example.com'
        }
      }
    end

    subject { response }

    context 'user is signed in' do
      let!(:user) { create(:user_confirmed) }

      context 'authentication is linked to user' do
        let!(:authentication_facebook) { create(:authentication_facebook, user: user) }

        before do
          sign_in user
          get :facebook
        end

        it { should redirect_to(root_path) }
        its('flash notice') { flash[:notice].should == "Already linked that account!" }
      end

      context 'authentication is not linked to user' do
        let!(:other_user) { create(:user_confirmed) }
        let!(:authentication_facebook) { create(:authentication_facebook, user: other_user) }

        before do
          sign_in user
          get :facebook
        end

        it { should redirect_to(root_path) }
        its('flash notice') { flash[:notice].should == "Successfully linked that account!" }
      end
    end

    context 'user is not signed in' do
      let!(:user) { create(:user_confirmed) }

      context 'authentication is linked to user' do
        let!(:authentication_facebook) { create(:authentication_facebook, user: user) }

        before do
          get :facebook
        end

        it { should redirect_to(root_path) }
        its('flash notice') { flash[:notice].should == I18n.t('devise.omniauth_callbacks.success', kind: 'Facebook') }
      end

      context 'authentication is not linked to user' do
        context 'a new user is valid' do
          before do
            get :facebook
          end

          it { should redirect_to(root_path) }
          its('flash notice') { flash[:notice].should == I18n.t('devise.omniauth_callbacks.success', kind: 'Facebook') }
        end

        context 'a new user is not valid' do
          before do
            @request.env['omniauth.auth'] = {} # invalid data from provider
            get :facebook
          end

          it { should redirect_to(new_user_registration_path) }
          its('flash notice') { flash[:notice].should == "Invalid data from provider!" }
        end
      end
    end
  end
end
