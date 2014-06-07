require 'spec_helper'

describe Locale do
  subject { Locale } # subject is a class, not an instance

  before do
    subject.stub(:supported_languages).and_return(['en', 'pl'])
  end

  describe '.supported_language?' do
    it 'should accept string as language' do
      expect(subject.supported_language?('en')).to be true
      expect(subject.supported_language?('pl')).to be true
      expect(subject.supported_language?('xy')).to be false
    end

    it 'should accept symbol as language' do
      expect(subject.supported_language?(:en)).to be true
      expect(subject.supported_language?(:pl)).to be true
      expect(subject.supported_language?(:xy)).to be false
    end
  end

  describe '.collection_of_languages' do
    it 'returns proper hash' do
      expect(subject.collection_of_languages).to eql({
        'English' => 'en',
        'Polish' => 'pl'
      })
    end
  end
end
