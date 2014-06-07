require 'spec_helper'

describe NewsletterService do
  let(:newsletter) { create(:newsletter) }
  let(:last_user_id) { 100 }
  let(:recipients_limit) { 20 }

  subject { NewsletterService.new(newsletter.id, recipients_limit) }

  describe '.new' do
    its(:newsletter_id) { should eql newsletter.id }
    its(:recipients_limit) { should eql recipients_limit }
  end

  describe '#run' do
    before do
      expect(subject).to receive(:can_be_send?).and_return(can_be_send?)
    end

    context 'when newsletter can be send' do
      let(:can_be_send?) { true }

      it 'calls process' do
        expect(subject).to receive(:process)
        subject.run
      end
    end

    context 'when newsletter cannot be send' do
      let(:can_be_send?) { false }

      it "doesn't calls process" do
        expect(subject).not_to receive(:process)
        subject.run
      end
    end
  end

  describe '#can_be_send?' do
    before do
      subject.stub(:newsletter) { fake_newsletter }
    end

    context 'when newsletter is nil' do
      let(:fake_newsletter) { nil }

      its(:can_be_send?) { should be false }
    end

    context 'when newsletter is stopped' do
      let(:fake_newsletter) { build(:newsletter, stopped: true) }

      its(:can_be_send?) { should be false }
    end

    context 'when newsletter is not stopped' do
      context 'when newsletter is finished' do
        let(:fake_newsletter) { build(:newsletter, stopped: false) }

        its(:can_be_send?) { should be false }
      end

      context 'when newsletter is not finished' do
        let(:fake_newsletter) { build(:newsletter, stopped: false, finished_at: nil) }

        its(:can_be_send?) { should be true }
      end
    end
  end

  describe '#newsletter' do
    before do
      expect(Newsletter).to receive(:find_by).with(id: newsletter.id).and_return(newsletter)
    end

    it 'should find newsletter by id' do
      subject.newsletter
    end

    it 'calls find newsletter only once' do
      subject.newsletter
      subject.newsletter
    end
  end

  describe '#process' do
    context 'when list of recipients is empty' do
      before do
        subject.stub(:recipients) { [] }
      end

      it 'calls mark_as_finished' do
        expect(subject).to receive(:mark_as_finished)
        subject.process
      end
    end

    context 'when list of recipients is not empty' do
      before do
        subject.stub(:recipients) { [double] }
      end

      it 'calls send_newsletter' do
        expect(subject).to receive(:send_newsletter)
        subject.process
      end
    end
  end

  describe '#recipients' do
    context "when newsletter's language is blank" do
      let(:newsletter) { create(:newsletter, language: '') }

      it 'calls recipients_all' do
        expect(subject).to receive(:recipients_all)
        subject.recipients
      end
    end

    context "when newsletter's language is not blank" do
      let(:newsletter) { create(:newsletter, language: I18n.default_locale) }

      it 'calls recipients_with_preferred_language' do
        expect(subject).to receive(:recipients_with_preferred_language)
        subject.recipients
      end
    end
  end

  describe '#recipients_all' do
    before do
      subject.stub(:last_user_id) { last_user_id }
      subject.stub(:recipients_limit) { recipients_limit }
    end

    it 'returns limited amount of users with id greater than last_user_id' do
      users, active_users = double, double
      expect(User).to receive(:active).and_return(active_users)
      expect(active_users).to receive(:where).with('id > ?', last_user_id).and_return(users)
      expect(users).to receive(:take).with(recipients_limit)
      subject.recipients_all
    end
  end

  describe '#recipients_with_preferred_language' do
    before do
      subject.stub(:last_user_id) { last_user_id }
      subject.stub(:recipients_limit) { recipients_limit }
    end

    it 'returns limited amount of users with id greater than last_user_id and preferred language' do
      users, active_users, users_with_preferred_language = double, double, double
      expect(User).to receive(:active).and_return(active_users)
      expect(active_users).to receive(:where).with('id > ?', last_user_id).and_return(users)
      expect(users).to receive(:where).with(preferred_language: newsletter.language).and_return(users_with_preferred_language)
      expect(users_with_preferred_language).to receive(:take).with(recipients_limit)
      subject.recipients_with_preferred_language
    end
  end

  describe '#last_user_id' do
    its(:last_user_id) { should eql newsletter.last_user_id }
  end

  describe '#mark_as_finished' do
    it 'sets finished_at for newsletter' do
      Timecop.freeze do
        expect(subject.newsletter).to receive(:update_attribute).with(:finished_at, DateTime.now)
        subject.mark_as_finished
      end
    end
  end

  describe '#send_newsletter' do
    let(:users_amount) { 5 }
    let(:users) { User.all }

    before do
      users_amount.times do
        create(:user)
      end

      expect(newsletter.last_user_id).to eql 0
      expect(newsletter.sent_email_count).to eql 0
    end

    context 'when users amount is bigger than recipients limit' do
      let(:recipients_limit) { users_amount - 1 }

      it 'sends newsletter to limited recipients' do
        expect(subject.send_newsletter).to eql :continue

        newsletter.reload
        expect(newsletter.last_user_id).to eql users[recipients_limit-1].id
        expect(newsletter.sent_email_count).to eql recipients_limit
      end
    end

    context 'when users amount is less than recipients limit' do
      let(:recipients_limit) { users_amount + 1 }

      it 'sends newsletter to all recipients' do
        expect(subject.send_newsletter).to eql :continue

        newsletter.reload
        expect(newsletter.last_user_id).to eql users[users_amount-1].id
        expect(newsletter.sent_email_count).to eql users_amount
      end
    end
  end

  describe '#can_send_to_user?' do
    context 'when user has enabled newsletter' do
      let(:user) { build(:user, enabled_newsletter: true) }

      it 'returns true' do
        expect(subject.can_send_to_user?(user)).to be true
      end
    end

    context 'when user has disabled newsletter' do
      let(:user) { build(:user, enabled_newsletter: false) }

      context 'when newsletter has enabled force send' do
        let(:newsletter) { create(:newsletter, enabled_force: true) }

        it 'returns true' do
          expect(subject.can_send_to_user?(user)).to be true
        end
      end

      context 'when newsletter has no enabled force send' do
        let(:newsletter) { create(:newsletter, enabled_force: false) }

        it 'returns false' do
          expect(subject.can_send_to_user?(user)).to be false
        end
      end
    end
  end

  describe '#send_to_user' do
    let(:user) { build(:user) }

    it 'sends newsletter to user' do
      newsletter_mailer = double
      expect(NewsletterMailer).to receive(:newsletter).with(user, newsletter.subject, newsletter.body).and_return(newsletter_mailer)
      expect(newsletter_mailer).to receive(:deliver)

      subject.send_to_user(user)
    end
  end
end
