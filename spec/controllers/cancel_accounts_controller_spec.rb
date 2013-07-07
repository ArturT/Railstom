require 'spec_helper'

describe CancelAccountsController do
  let(:user) { create(:user_confirmed) }

  describe '#edit' do
    context 'when user has own password' do
      before do
        sign_in user
        get :edit, locale: I18n.locale
      end

      it { should_not set_the_flash[:warning].now }
      it { should render_template(:edit) }
    end

    context 'when user has no own password' do
      before do
        sign_in user
        controller.current_user.stub(:password_changed?).and_return(false)
        get :edit, locale: I18n.locale
      end

      it { should set_the_flash[:warning].now }
      it { should render_template(:edit) }
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

      it { should set_the_flash[:success] }
      it { expect(controller.current_user).not_to exist_in_database }
      it 'returns 302 status code' do
        expect(response.code).to eql '302'
      end
    end

    context 'invalid password' do
      before do
        controller.current_user.stub(:valid_password?).and_return(false)
        delete :destroy, locale: I18n.locale, user: {}
      end

      it { should set_the_flash[:error].now }
      it { expect(controller.current_user).to exist_in_database }
      it { should render_template(:edit) }
    end
  end
end
