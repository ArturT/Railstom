require 'spec_helper'

describe ApplicationHelper do
  describe '#default_page_path' do
    context 'locale: en' do
      before { I18n.stub(:locale).and_return(:en) }

      it { expect(default_page_path('contact')).to eql('/en/pages/contact') }
    end

    context 'locale: pl' do
      before { I18n.stub(:locale).and_return(:pl) }

      it { expect(default_page_path('contact')).to eql('/pl/pages/contact') }
    end
  end

  describe '#default_locale_page_path' do
    context 'locale: en' do
      before { I18n.stub(:locale).and_return(:en) }

      it { expect(default_locale_page_path('contact')).to eql('/en/locale_pages/contact') }
    end

    context 'locale: pl' do
      before { I18n.stub(:locale).and_return(:pl) }

      it { expect(default_locale_page_path('contact')).to eql('/pl/locale_pages/contact') }
    end
  end
end
