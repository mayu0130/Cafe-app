require 'rails_helper'

RSpec.describe Comment, type: :model do
  let(:user) { create(:user) }
  let(:post) { create(:post, user: user) }
  let(:comment) { build(:comment, user: user, post: post) }

  describe 'バリデーション' do
    it '有効なコメントを保存できる' do
      expect(comment).to be_valid
    end

    it 'content が空では無効' do
      comment.content = ''
      expect(comment).to be_invalid
    end

    it 'content が1文字では無効' do
      comment.content = 'A'
      expect(comment).to be_invalid
    end

    it 'content が2文字以上なら有効' do
      comment.content = 'AB'
      expect(comment).to be_valid
    end

    it 'content が200文字なら有効' do
      comment.content = 'A' * 200
      expect(comment).to be_valid
    end

    it 'content が201文字では無効' do
      comment.content = 'A' * 201
      expect(comment).to be_invalid
    end
  end

  describe 'アソシエーション' do
    it { should belong_to(:post) }
    it { should belong_to(:user) }
  end
end
