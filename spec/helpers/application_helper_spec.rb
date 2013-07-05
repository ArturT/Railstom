require 'spec_helper'

describe ApplicationHelper do
  describe '#lpage_path' do
    context 'locale: en' do
      before { I18n.stub(:locale).and_return(:en) }

      it { expect(lpage_path('contact')).to eql('/en/locale_pages/contact') }
    end

    context 'locale: pl' do
      before { I18n.stub(:locale).and_return(:pl) }

      it { expect(lpage_path('contact')).to eql('/pl/locale_pages/contact') }
    end
  end
end
