require 'spec_helper'

describe GeneratorService do
  let(:nickname) { 'NickName' }
  let(:name) { 'Name' }
  let(:omniauth_hash) do
    {
      'info' => {
        'nickname' => nickname,
        'name' => name
      }
    }
  end

  subject { isolate(GeneratorService) }

  describe '#password' do
    it 'returns password with specified length' do
      expect(subject.password(6).length).to eql 6
      expect(subject.password(8).length).to eql 8
    end
  end

  describe '#nickname_with_omniauth' do
    context 'when nickname has value' do
      it 'returns nickname' do
        expect(subject.nickname_with_omniauth).to eql nickname
      end
    end

    context 'when nickname has no value' do
      let(:nickname) { nil }

      it 'returns name' do
        expect(subject.nickname_with_omniauth).to eql name
      end

      context 'when nickname has spaces and dots' do
        let(:name) { 'First Middle Last.' }

        it 'returns name without spaces and dots' do
          expect(subject.nickname_with_omniauth).to eql 'FirstMiddleLast'
        end
      end
    end
  end
end
