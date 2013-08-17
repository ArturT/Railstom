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
    context 'when :locale param is nil' do
      subject { I18n.locale }

      context 'when :locale session has supported language' do
        before do
          session[:locale] = session_locale
          get :index
        end

        Locale.supported_languages.each do |language|
          context "language #{language}" do
            let(:session_locale) { language }

            it { should be_eql(language.to_sym) }
          end
        end
      end

      context 'when :locale session has not supported language' do
        context 'when HTTP_ACCEPT_LANGUAGE has supported language' do
          before do
            request.env['HTTP_ACCEPT_LANGUAGE'] = http_accept_language
            get :index
          end

          Locale.supported_languages.each do |language|
            context "language #{language}" do
              let(:http_accept_language) { language }

              it { should be_eql(language.to_sym) }

              it 'set session locale' do
                expect(session[:locale]).to be_eql(language.to_sym)
              end
            end
          end
        end
      end

      context 'for blank language' do
        before do
          get :index
        end

        it 'flash notice is nil' do
          expect(flash[:notice]).to be_nil
        end

        it 'response success' do
          response.should be_success
        end

        it 'locale should be default' do
          should be_eql(I18n.default_locale.to_sym)
        end
      end
    end

    context 'when :locale param is not nil' do
      context 'for supported languages' do
        subject { I18n.locale }

        before { get :index, locale: locale }

        Locale.supported_languages.each do |language|
          context "language #{language}" do
            let(:locale) { language }

            it { should be_eql(language.to_sym) }

            it 'set session locale' do
              expect(session[:locale]).to be_eql(language.to_sym)
            end
          end
        end
      end

      context 'for not supported languages' do
        before do
          @current_locale = I18n.locale
          get :index, locale: 'xx'
        end

        it { expect(flash[:notice]).to eql I18n.t('controllers.application.notice.not_supported_language') }
        it { response.should redirect_to root_path(@current_locale) }
      end
    end
  end
end
