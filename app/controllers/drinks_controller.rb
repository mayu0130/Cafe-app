class DrinksController < ApplicationController
  def new
    @questions = [
      { id: 1, question: '朝起きた時の気分は？', options: ['すっきり目覚めたい！', 'ゆっくり始めたい気分', 'パワフルに活動したい', 'リラックスして一日を始めたい'] },
      { id: 2, question: 'お気に入りのスナックは？', options: ['抹茶を使ったスイーツ', 'ヘルシーなナッツやドライフルーツ', 'チョコレートやクッキー', '和菓子や煎餅'] },
      { id: 3, question: '理想のカフェタイムはどんなシチュエーション？', options: ['本を読みながら静かに過ごす', '健康志向のランチを楽しむ', '友達とおしゃべりしながら楽しく過ごす', '自然光の差し込むカフェでリラックスする'] }
    ]
  end

  def result
    if params[:answers].nil?
      flash[:error] = 'すべての質問に答えてください。'
      redirect_to new_drink_path
      return
    end

    answers = params[:answers]
    answer_counts = {'A' => 0, 'B' => 0, 'C' => 0, 'D' => 0}

    # 回答内容をカウント
    answers.each do |key, value|
      case value
      when 'すっきり目覚めたい！', '抹茶を使ったスイーツ', '本を読みながら静かに過ごす'
        answer_counts['A'] += 1
      when 'ゆっくり始めたい気分', 'ヘルシーなナッツやドライフルーツ', '健康志向のランチを楽しむ'
        answer_counts['B'] += 1
      when 'パワフルに活動したい', 'チョコレートやクッキー', '友達とおしゃべりしながら楽しく過ごす'
        answer_counts['C'] += 1
      when 'リラックスして一日を始めたい', '和菓子や煎餅', '自然光の差し込むカフェでリラックスする'
        answer_counts['D'] += 1
      end
    end

    result_cafe_time = if answer_counts['A'] > answer_counts['B'] && answer_counts['A'] > answer_counts['C']
      '抹茶系がおすすめ！'
    elsif answer_counts['B'] > answer_counts['C']
      'ソイ系がおすすめ！'
    elsif answer_counts['C'] > answer_counts['D']
      'カフェラテがおすすめ！'
    else
      'ほうじ茶系がおすすめ！'
    end

    @result = result_cafe_time
  end
end
