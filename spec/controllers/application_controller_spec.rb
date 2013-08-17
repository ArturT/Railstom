require 'spec_helper'

describe ApplicationController do
  # Anonymous controller
  controller do
    def index
      render nothing: true
    end
  end

  describe '#logout_blocked_user' do
    before do
      sign_in user
    end

    context 'when user active' do
      let(:user) { create(:user) }

      before do
        get :index, locale: I18n.locale
      end

      it { expect(response.code).to eql '200' }
    end

    context 'when user blocked' do
      let(:user) { create(:user, blocked: true) }

      before do
        expect(controller).to receive(:sign_out).with(:user)

        get :index, locale: I18n.locale
      end

      its('flash notice') { expect(flash[:notice]).to eql I18n.t('controllers.application.notice.your_account_is_blocked') }
      its(:response) { expect(response.code).to eql '302' }
    end
  end

  describe '#set_locale' do
    context 'for supported languages' do
      it 'english' do
        get :index, locale: 'en'

        expect(I18n.locale).to be_eql(:en)
      end

      it 'polish' do
        get :index, locale: 'pl'

        expect(I18n.locale).to be_eql(:pl)
      end
    end

    context 'for not supported languages' do
      before { @default_locale = I18n.locale }

      it 'should set default language, flash notice and redirect to root_path' do
        get :index, locale: 'xx'

        expect(flash[:notice]).not_to be_nil
        response.should redirect_to root_path(@default_locale)
      end
    end

    context 'for blank language' do
      it 'should do nothing' do
        get :index

        expect(flash[:notice]).to be_nil
        response.should be_success
      end
    end
  end
end
