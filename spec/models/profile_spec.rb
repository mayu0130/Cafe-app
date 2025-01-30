require 'rails_helper'

RSpec.describe Profile, type: :model do
  let(:user) { create(:user) }
  let(:profile) { build(:profile, user: user) }

  describe 'バリデーション' do
    context '有効なプロフィールの場合' do
      it '保存できること' do
        expect(profile).to be_valid
      end
    end

    context 'nickname のバリデーション' do
      it '空では無効であること' do
        profile.nickname = ''
        expect(profile).to be_invalid
      end

      it '50文字以内であれば有効であること' do
        profile.nickname = 'A' * 50
        expect(profile).to be_valid
      end

      it '51文字以上では無効であること' do
        profile.nickname = 'A' * 51
        expect(profile).to be_invalid
      end
    end

    context 'mbti のバリデーション' do
      it '空でも有効であること' do
        profile.mbti = ''
        expect(profile).to be_valid
      end

      it '英大文字4文字（例: INFP）なら有効であること' do
        profile.mbti = 'INFP'
        expect(profile).to be_valid
      end

      it '小文字が含まれている場合は無効であること' do
        profile.mbti = 'infp'
        expect(profile).to be_invalid
      end

      it '5文字以上の場合は無効であること' do
        profile.mbti = 'INFPT'
        expect(profile).to be_invalid
      end
    end

    context 'address のバリデーション' do
      it '空でも有効であること' do
        profile.address = ''
        expect(profile).to be_valid
      end

      it '100文字以内であれば有効であること' do
        profile.address = 'A' * 100
        expect(profile).to be_valid
      end

      it '101文字以上では無効であること' do
        profile.address = 'A' * 101
        expect(profile).to be_invalid
      end
    end

    context 'introduction のバリデーション' do
      it '空では無効であること' do
        profile.introduction = ''
        expect(profile).to be_invalid
      end

      it '500文字以内であれば有効であること' do
        profile.introduction = 'A' * 500
        expect(profile).to be_valid
      end

      it '501文字以上では無効であること' do
        profile.introduction = 'A' * 501
        expect(profile).to be_invalid
      end
    end

    context 'x_link のバリデーション' do
      it '空でも有効であること' do
        profile.x_link = ''
        expect(profile).to be_valid
      end

      it '有効なURLなら有効であること' do
        profile.x_link = 'https://example.com'
        expect(profile).to be_valid
      end

      it '無効なURLなら無効であること' do
        profile.x_link = 'invalid-url'
        expect(profile).to be_invalid
      end
    end

    context 'instagram_link のバリデーション' do
      it '空でも有効であること' do
        profile.instagram_link = ''
        expect(profile).to be_valid
      end

      it '有効なURLなら有効であること' do
        profile.instagram_link = 'https://instagram.com/example'
        expect(profile).to be_valid
      end

      it '無効なURLなら無効であること' do
        profile.instagram_link = 'invalid-url'
        expect(profile).to be_invalid
      end
    end
  end

  describe 'アソシエーション' do
    it { should belong_to(:user) }
    it { should have_one_attached(:avatar) }
  end
end
