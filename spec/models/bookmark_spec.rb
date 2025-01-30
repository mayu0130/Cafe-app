require 'rails_helper'

RSpec.describe Bookmark, type: :model do
  let(:user) { create(:user) }
  let(:post) { create(:post) }
  let(:bookmark) { build(:bookmark, user: user, post: post) }

  describe 'バリデーション' do
    it '有効なブックマークは保存できる' do
      expect(bookmark).to be_valid
    end

    it '同じユーザーが同じ投稿を2回ブックマークできない' do
      create(:bookmark, user: user, post: post)
      duplicate_bookmark = build(:bookmark, user: user, post: post)
      expect(duplicate_bookmark).to be_invalid
      expect(duplicate_bookmark.errors[:user_id]).to include('はすでに存在します')
    end
  end

  describe 'アソシエーション' do
    it { should belong_to(:user) }
    it { should belong_to(:post) }
  end
end
