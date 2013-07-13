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

  describe '#copyright_year_of_founding' do
    let(:current_year) { Time.zone.now.year }

    context 'when year of founding is equal current year' do
      let(:year) { current_year }

      it { expect(copyright_year_of_founding(year)).to eql "&copy; #{year}" }
    end

    context 'when year of founding is less than current year' do
      let(:year) { current_year - 1 }

      it { expect(copyright_year_of_founding(year)).to eql "&copy; #{year} - #{current_year}" }
    end
  end
end
