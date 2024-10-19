class OgpCreator
  require 'mini_magick'
  BASE_IMAGE_PATH = './app/assets/images/ogp.png'
  GRAVITY = 'center'
  TEXT_POSITION = '0,0'
  FONT = './app/assets/fonts/NotoSansJP-VariableFont_wght.ttf'
  FONT_SIZE = 100
  INDENTION_COUNT = 16
  ROW_LIMIT = 10


  def self.build(text, post_id)
    text = prepare_text(text)
    image = MiniMagick::Image.open(BASE_IMAGE_PATH)
    image.combine_options do |config|
      config.font FONT
      config.fill 'white'
      config.gravity GRAVITY
      config.pointsize FONT_SIZE
      config.draw "text #{TEXT_POSITION} '#{text}'"
    end

    # ファイル名を投稿IDに基づいて保存
  output_path = "./public/images/ogp_#{post_id}.png"
  image.write(output_path)
  output_path  # 生成された画像のパスを返す
end

  private
  def self.prepare_text(text)
    text.to_s.scan(/.{1,#{INDENTION_COUNT}}/)[0...ROW_LIMIT].join("\n")
  end
end