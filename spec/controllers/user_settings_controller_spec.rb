require 'spec_helper'

describe UserSettingsController do
  let(:user) { create(:user) }

  subject { response }

  before do
    sign_in user
  end

  describe '#edit' do
    before do
      get :edit, locale: I18n.locale
    end

    it { should be_success }
    it { should render_template(:edit) }
  end

  describe '#update' do
    let(:nickname) { 'nickname' }
    let(:user_params) do
      {
        'avatar' => '',
        'avatar_cache' => '',
        'remove_avatar' => '',
        'enabled_newsletter' => true,
        'nickname' => nickname
      }
    end
    let(:expected_user_params) { user_params }

    context 'valid user params' do
      shared_examples 'update user attributes' do
        before do
          expect(controller.current_user).to receive(:update_attributes).with(expected_user_params).and_return(true)
          patch :update, locale: I18n.locale, user: user_params
        end

        its('flash success') { expect(flash[:success]).to eql I18n.t('user_settings.update.successfully_saved') }
        it { should redirect_to edit_user_settings_url }
      end

      context 'when user has nickname' do
        context 'when nickname in params is blank' do
          let(:nickname) { '' }
          it_behaves_like 'update user attributes'
        end

        context 'when nickname in params is not blank' do
          it_behaves_like 'update user attributes'
        end
      end

      context 'when user has no nickname' do
        let(:user) { create(:user, nickname: nil) }

        context 'when nickname in params is blank' do
          let(:nickname) { '' }
          before { expected_user_params.delete('nickname') }
          it_behaves_like 'update user attributes'
        end

        context 'when nickname in params is not blank' do
          it_behaves_like 'update user attributes'
        end
      end
    end

    context 'invalid user params' do
      before do
        expect(controller.current_user).to receive(:update_attributes).with(user_params).and_return(false)
        patch :update, locale: I18n.locale, user: user_params
      end

      its('flash success') { expect(flash[:success]).to be_nil }
      it { should be_success }
      it { should render_template(:edit) }
    end
  end

  describe '#authentication' do
    before do
      get :authentication, locale: I18n.locale
    end

    it { should be_success }
    it { should render_template(:authentication) }
  end
end
