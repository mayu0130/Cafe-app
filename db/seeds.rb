# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Example:
#
#   ["Action", "Comedy", "Drama", "Horror"].each do |genre_name|
#     MovieGenre.find_or_create_by!(name: genre_name)
#   end

tags = ['コーヒー', '紅茶', '抹茶', 'スイーツ', 'パン', '軽食', 'モーニング', 'ランチ', 'ディナー', '夜カフェ', 'wi-fiあり', '電源あり', '長居OK', '駅近', '駐車場あり', '予約可', '静かでリラックスできる', 'おしゃれな雰囲気']

tags.each do |tag|
  Tag.find_or_create_by(name: tag)
end
