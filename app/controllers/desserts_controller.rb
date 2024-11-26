class DessertsController < ApplicationController
  def new
    @questions = [
      { id: 1, question: '今日の気分に一番近いのは？', options: ['さっぱり', '甘いもの', '温かいもの', '特別なデザート'] },
      { id: 2, question: '好きな飲み物は？', options: ['緑茶', 'コーヒー', 'ホットミルク', 'フルーツジュース'] },
      { id: 3, question: 'デザートを食べるシチュエーションは？', options: ['食後', 'カフェタイム', 'おうち', '外出先'] }
    ]
  end

  def result
    # answersがnilの場合は処理を中止してエラーメッセージを表示
    if params[:answers].nil?
      flash[:error] = 'すべての質問に答えてください。'
      redirect_to new_dessert_path
      return
    end

    answers = params[:answers]
    answer_counts = {'A' => 0, 'B' => 0, 'C' => 0, 'D' => 0}

    # 回答内容をカウント
    answers.each do |key, value|
      case value
      when 'さっぱり', '緑茶', '食後'
        answer_counts['A'] += 1
      when '甘いもの', 'コーヒー', 'カフェタイム'
        answer_counts['B'] += 1
      when '温かいもの', 'ホットミルク', 'おうち'
        answer_counts['C'] += 1
      when '特別なデザート', 'フルーツジュース', '外出先'
        answer_counts['D'] += 1
      end
    end

    # 結果となるデザートを決定
    result_dessert = if answer_counts['A'] > answer_counts['B'] && answer_counts['A'] > answer_counts['C']
      'レアチーズケーキ'
    elsif answer_counts['B'] > answer_counts['C']
      'チョコレートケーキ'
    elsif answer_counts['C'] > answer_counts['D']
      'アップルパイ'
    else
      'フルーツパフェ'
    end

    @result = result_dessert
  end
end
