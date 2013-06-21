require 'spec_helper'

describe PagesController do
  subject { response }

  describe '#locale_show' do
    Locale.supported_languages.each do |locale|
      context "locale: #{locale}" do
        %w(contact).each do |page|
          context "on GET to /#{locale}/pages/#{page}" do
            before do
              get :locale_show, locale: I18n.locale, id: page
            end

            it { should be_success }
            it { should render_template(page) }
          end
        end
      end
    end
  end
end
