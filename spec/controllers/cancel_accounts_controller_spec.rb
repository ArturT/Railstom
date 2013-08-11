require 'spec_helper'

describe CancelAccountsController do
  let(:user) { create(:user) }

  describe '#edit' do
    context 'when user has own password' do
      before do
        sign_in user
        get :edit, locale: I18n.locale
      end

      it { should render_template(:edit) }

      it "doesn't set the flash warning" do
        expect(flash[:warning]).to eql nil
      end
    end

    context 'when user has no own password' do
      before do
        sign_in user
        controller.current_user.stub(:password_changed?).and_return(false)
        get :edit, locale: I18n.locale
      end

      it { should render_template(:edit) }

      it 'sets the flash warning' do
        expect(flash[:warning]).to eql I18n.t('controllers.cancel_accounts.flash.not_set_password_html', url: edit_user_registration_path)
      end
    end
  end

  describe '#destroy' do
    before do
      sign_in user
    end

    context 'valid password' do
      before do
        controller.current_user.stub(:valid_password?).and_return(true)
        delete :destroy, locale: I18n.locale, user: {}
      end

      it { expect(controller.current_user).not_to exist_in_database }

      it 'sets the flash success' do
        expect(flash[:success]).to eql I18n.t('controllers.cancel_accounts.flash.account_deleted', url: edit_user_registration_path)
      end

      it 'returns 302 status code' do
        expect(response.code).to eql '302'
      end
    end

    context 'invalid password' do
      before do
        controller.current_user.stub(:valid_password?).and_return(false)
        delete :destroy, locale: I18n.locale, user: {}
      end

      it { expect(controller.current_user).to exist_in_database }
      it { should render_template(:edit) }

      it 'sets the flash error' do
        expect(flash[:error]).to eql I18n.t('controllers.cancel_accounts.flash.not_valid_password', url: edit_user_registration_path)
      end
    end
  end
end
