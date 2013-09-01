require 'spec_helper'

describe AvatarUploader do
  let(:user) { create(:user) }
  let(:path_to_file) { fixture_path + 'images/avatar.png' }

  before do
    AvatarUploader.enable_processing = true
    @uploader = AvatarUploader.new(user, :avatar)
    @uploader.store!(File.open(path_to_file))
  end

  after do
    AvatarUploader.enable_processing = false
    @uploader.remove!
  end

  context 'the small version' do
    it 'should scale down a landscape image to be exactly 64 by 64 pixels' do
      @uploader.small.should have_dimensions(64, 64)
    end
  end

  context 'the normal version' do
    it 'should scale down a landscape image to be exactly 160 by 160 pixels' do
      @uploader.normal.should have_dimensions(160, 160)
    end
  end

  it 'avatar has permissions 0644' do
    @uploader.should have_permissions(0644)
  end
end
