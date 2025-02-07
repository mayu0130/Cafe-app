require 'rails_helper'

RSpec.describe Post, type: :model do
  let(:post) { build(:post) }

  describe 'バリデーション' do
    context '有効なPostの場合' do
      it '保存できること' do
        expect(post).to be_valid
      end
    end

    context 'cafe_nameが無効な場合' do
      it '空の場合は無効であること' do
        post.cafe_name = ''
        expect(post).to be_invalid
      end

      it '1文字の場合は無効であること' do
        post.cafe_name = 'A'
        expect(post).to be_invalid
      end

      it '101文字の場合は無効であること' do
        post.cafe_name = 'A' * 101
        expect(post).to be_invalid
      end
    end

    context 'bodyが無効な場合' do
      it '空の場合は無効であること' do
        post.body = ''
        expect(post).to be_invalid
      end

      it '10文字未満の場合は無効であること' do
        post.body = 'a' * 9
        expect(post).to be_invalid
      end

      it '2000文字を超える場合は無効であること' do
        post.body = 'a' * 2001
        expect(post).to be_invalid
      end
    end

    context 'addressが無効な場合' do
      it '空の場合は無効であること' do
        post.address = ''
        expect(post).to be_invalid
      end

      it '1文字の場合は無効であること' do
        post.address = 'A'
        expect(post).to be_invalid
      end

      it '51文字の場合は無効であること' do
        post.address = 'A' * 51
        expect(post).to be_invalid
      end
    end

    context 'addressが有効な場合' do
      it '2文字以上50文字以内なら保存できること' do
        post.address = '東京都渋谷区'
        expect(post).to be_valid
      end
    end

    context 'cafe_linkが有効な場合' do
      it 'httpリンクで保存できること' do
        post.cafe_link = 'http://example.com'
        expect(post).to be_valid
      end

      it 'httpsリンクで保存できること' do
        post.cafe_link = 'https://example.com'
        expect(post).to be_valid
      end

      it '空でも保存できること' do
        post.cafe_link = ''
        expect(post).to be_valid
      end
    end

    context 'cafe_linkが無効な場合' do
      it 'httpでもhttpsでもないURLでは無効であること' do
        post.cafe_link = 'ftp://example.com'
        expect(post).to be_invalid
      end

      it '無効なURL（文字列）では無効であること' do
        post.cafe_link = 'not_a_url'
        expect(post).to be_invalid
      end
    end
  end

  describe 'アソシエーション' do
    it { should belong_to(:user) }
    it { should have_many(:comments).dependent(:destroy) }
    it { should have_many(:bookmarks).dependent(:destroy) }
    it { should have_and_belong_to_many(:tags) }
    it { should have_one_attached(:image) }
  end

  describe 'ジオコーディング' do
    let(:post_with_address) { build(:post, address: '東京都渋谷区') }

    it '住所が変更されたときに geocode を実行する' do
      expect(post_with_address).to receive(:geocode)
      post_with_address.valid?
    end

    it '住所が変更されない場合、geocode は実行されない' do
      post_with_address.save!
      allow(post_with_address).to receive(:geocode)

      post_with_address.update(body: '新しい内容')
      expect(post_with_address).not_to have_received(:geocode)
    end
  end

  describe 'Ransackの設定' do
    it 'ransackable_attributes が正しい値を返す' do
      expect(Post.ransackable_attributes).to match_array(%w[cafe_name body address])
    end

    it "ransackable_associations がタグ関連付けのみを返す" do
      expect(Post.ransackable_associations).to eq(%w[tags])
    end
  end
end
