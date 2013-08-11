require 'spec_helper'

describe RegistrationsController do
  subject { response }

  login_user

  describe '#reset_password' do
    # logout path is defined in after_sign_out_path_for in application_controller.rb
    it 'redirects to /:locale/users/password/new after logout user' do
      get :reset_password, locale: I18n.locale
      expect(response).to redirect_to(new_user_password_path)
    end
  end

  describe '#edit' do
    context "when user's password not changed" do
      before do
        expect(controller.current_user).to receive(:password_changed?).and_return(false)
        get :edit, locale: I18n.locale
      end

      it 'show_change_password_form should be false' do
        expect(assigns(:show_change_password_form)).to be_false
      end

      it { should be_success }
    end

    context "when user's password changed" do
      before do
        expect(controller.current_user).to receive(:password_changed?).and_return(true)
        get :edit, locale: I18n.locale
      end

      it 'show_change_password_form should be true' do
        expect(assigns(:show_change_password_form)).to be_true
      end

      it { should be_success }
    end
  end

  describe '#update' do
    context "when user's password not changed" do
      before do
        expect(controller.current_user).to receive(:password_changed?).and_return(false)
        put :update, user: {}, locale: I18n.locale
      end

      it 'show_change_password_form should be false' do
        expect(assigns(:show_change_password_form)).to be_false
      end

      it { should be_success }
    end

    context "when user's password changed" do
      before do
        expect(controller.current_user).to receive(:password_changed?).and_return(true)
        put :update, user: {}, locale: I18n.locale
      end

      it 'show_change_password_form should be true' do
        expect(assigns(:show_change_password_form)).to be_true
      end

      it { should be_success }
    end
  end
end
