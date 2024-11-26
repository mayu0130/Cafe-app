# app/controllers/coffee_beans_controller.rb

class CoffeeBeansController < ApplicationController
  def new
    @questions = [
      { id: 1, question: 'コーヒーを飲むタイミングは？', options: ['朝一番', '昼食後', '夕方', '夜'] },
      { id: 2, question: '好きなコーヒーの味わいは？', options: ['酸味が強い', 'バランス良く酸味', 'コクが強い', '甘味がある'] },
      { id: 3, question: 'コーヒーの産地で選ぶなら？', options: ['アフリカ', '南米', 'アジア', '島国'] }
    ]
  end

  def result
    # answersがnilの場合は処理を中止してエラーメッセージを表示
    if params[:answers].nil?
      flash[:error] = 'すべての質問に答えてください。'
      redirect_to new_coffee_bean_path
      return
    end

    answers = params[:answers]
    answer_counts = {'A' => 0, 'B' => 0, 'C' => 0, 'D' => 0}

    # 回答内容をカウント
    answers.each do |key, value|
      case value
      when '朝一番', '酸味が強い', 'アフリカ'
        answer_counts['A'] += 1
      when '昼食後', 'バランス良く酸味', '南米'
        answer_counts['B'] += 1
      when '夕方', 'コクが強い', 'アジア'
        answer_counts['C'] += 1
      when '夜', '甘味がある', '島国'
        answer_counts['D'] += 1
      end
    end

    result_bean = if answer_counts['A'] > answer_counts['B'] && answer_counts['A'] > answer_counts['C']
      'エチオピア豆'
    elsif answer_counts['B'] > answer_counts['C']
      'コロンビア豆'
    elsif answer_counts['C'] > answer_counts['D']
      'ブラジル豆'
    else
      'ハワイ・コナ豆'
    end

    @result = result_bean
  end
end
