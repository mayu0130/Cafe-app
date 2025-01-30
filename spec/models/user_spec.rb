require 'rails_helper'

RSpec.describe User, type: :model do
  let(:user) { build(:user) }
  let(:other_user) { create(:user) }

  describe 'バリデーション' do
    context '有効なユーザーの場合' do
      it '保存できること' do
        expect(user).to be_valid
      end
    end

    context 'emailが無効な場合' do
      it '空の場合は無効であること' do
        user.email = ''
        expect(user).to be_invalid
      end

      it '重複した場合は無効であること' do
        user2 = create(:user, email: 'test@example.com')
        user.email = 'test@example.com'
        expect(user).to be_invalid
      end
    end

    context 'passwordが無効な場合' do
      it '空の場合は無効であること' do
        user.password = ''
        expect(user).to be_invalid
      end

      it '6文字未満の場合は無効であること' do
        user.password = 'short'
        expect(user).to be_invalid
      end
    end
  end

  describe 'アソシエーション' do
    it { should have_many(:posts).dependent(:destroy) }
    it { should have_many(:comments).dependent(:destroy) }
    it { should have_one(:profile).dependent(:destroy) }
    it { should have_many(:bookmarks).dependent(:destroy) }
    it { should have_many(:bookmark_posts).through(:bookmarks).source(:post) }
    it { should have_many(:following_relationships).dependent(:destroy) }
    it { should have_many(:followings).through(:following_relationships).source(:following) }
    it { should have_many(:follower_relationships).dependent(:destroy) }
    it { should have_many(:followers).through(:follower_relationships).source(:follower) }
  end

  describe '#display_name' do
    it 'emailから@以前の部分を取得すること' do
      user.email = 'test@example.com'
      expect(user.display_name).to eq('test')
    end
  end

  describe '#mine?' do
    it 'postが自分のものであるか判定すること' do
      post = create(:post, user: user)
      expect(user.mine?(post)).to be_truthy
    end
  end

  describe '#prepare_profile' do
    it 'プロファイルが存在しない場合は新しいプロファイルを作成すること' do
      user.profile = nil
      expect(user.prepare_profile).to be_a(Profile)
    end

    it 'プロファイルが存在する場合はそのプロファイルを返すこと' do
      profile = create(:profile, user: user)
      user.profile = profile
      expect(user.prepare_profile).to eq(profile)
    end
  end

  describe '#avatar_image' do
  it 'プロファイルに画像があればその画像を返すこと' do
    profile = create(:profile, user: user, avatar: fixture_file_upload('spec/fixtures/avatar.png'))
    user.profile = profile
    expect(user.avatar_image).to be_a(ActiveStorage::Attached::One)
  end

  it 'プロファイルに画像がない場合はデフォルトのアイコンを返すこと' do
    user.profile = nil
    expect(user.avatar_image).to eq('<i class="fa-regular fa-user"></i>'.html_safe)
  end
end

  describe '#bookmark' do
    it '投稿をブックマークできること' do
      post = create(:post)
      user.bookmark(post)
      expect(user.bookmark?(post)).to be_truthy
    end
  end

  describe '#unbookmark' do
    it 'ブックマークを解除できること' do
      post = create(:post)
      user.bookmark(post)
      user.unbookmark(post)
      expect(user.bookmark?(post)).to be_falsy
    end
  end

  describe '#follow!' do
  it 'ユーザーをフォローできること' do
    user.save!
    other_user.save!
    initial_count = user.following_relationships.count
    user.follow!(other_user)
    expect(user.following_relationships.count).to eq(initial_count + 1)
    expect(user.following_relationships.last.following).to eq(other_user)
  end

  it 'すでにフォローしているユーザーを再度フォローしないこと' do
    user = create(:user)
    other_user = create(:user)
    user.follow!(other_user)
    initial_count = user.following_relationships.count
    expect(initial_count).to eq(1)
    user.follow!(other_user)
  end

end

  describe '#unfollow!' do

  it 'フォローしているユーザーをアンフォローできること' do
    user.save!
    other_user.save!
    user.follow!(other_user)
    initial_count = user.following_relationships.count

    user.unfollow!(other_user)
    expect(user.following_relationships.count).to eq(initial_count - 1)
    expect(user.has_followed?(other_user)).to be_falsey
  end

  it 'フォローしていないユーザーをアンフォローできないこと' do
    expect { user.unfollow!(other_user) }.to raise_error(ActiveRecord::RecordNotFound)
  end
end

  describe '#has_followed?' do

  it 'フォローしている場合はtrueを返すこと' do
    user.save!
    other_user.save!
    user.follow!(other_user)
    expect(user.has_followed?(other_user)).to be_truthy
  end
    it 'フォローしていない場合はfalseを返すこと' do
      expect(user.has_followed?(other_user)).to be_falsey
    end
  end

  describe '.from_omniauth' do
    it 'Google認証でユーザーを取得すること' do
      auth = OmniAuth::AuthHash.new({
        provider: 'google_oauth2',
        uid: '12345',
        info: { email: 'test@example.com' }
      })
      user = User.from_omniauth(auth)
      expect(user.email).to eq('test@example.com')
    end
  end
end
