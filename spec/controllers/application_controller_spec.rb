require 'spec_helper'

describe ApplicationController do
  # Anonymous controller
  controller do
    def index
      render nothing: true
    end
  end

  describe 'set locale' do
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
