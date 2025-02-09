class DailyAdvicesController < ApplicationController
  before_action :authenticate_user!  # Deviseを使用している場合

  def index
    @daily_advices = current_user.daily_advices.order(created_at: :desc).page(params[:page]).per(5)
  end

  def create

    if params[:question].blank?
      flash[:alert] = "質問を入力してください"
      redirect_to daily_advices_path
      return
    end

    usage_count = current_user.daily_usage_counts.find_or_create_by(used_date: Date.current)

    if usage_count.usage_count >= DailyAdvice::DAILY_LIMIT
      next_time = Time.current.end_of_day + 1.second
      flash[:error] = "1日#{DailyAdvice::DAILY_LIMIT}回までの制限に達しました。#{l(next_time, format: :short)}以降に再度お試しください。"
      redirect_to daily_advices_path
      return
    end

    question = params[:question]
    content = generate_coffee_advice(question)
    @daily_advice = current_user.daily_advices.build(
      content: content,
      question: question,
      generated_at: Time.current
    )

    if @daily_advice.save
      redirect_to daily_advices_path, notice: '新しいアドバイスが生成されました'
    else
      flash.now[:error] = 'アドバイスの生成に失敗しました'
      render :index
    end
  end

  def destroy
    @daily_advice = current_user.daily_advices.find(params[:id])
    if @daily_advice.destroy
      redirect_to daily_advices_path, notice: 'アドバイスを削除しました'
    else
      redirect_to daily_advices_path, alert: '削除に失敗しました'
    end
  end

  private

  def generate_coffee_advice(question)
    client = OpenAI::Client.new(access_token: ENV['OPENAI_API_KEY'])

    prompt = <<~PROMPT
      以下の質問に対して、カフェやコーヒーに関する具体的なアドバイスを提供してください。

      質問: #{question}

      フレンドリーで親しみやすい口調で、200文字程度でまとめてください。
    PROMPT

    response = client.chat(
      parameters: {
        model: 'gpt-3.5-turbo',
        messages: [{ role: 'user', content: prompt }],
        max_tokens: 300,
        temperature: 0.7
      }
    )

    response.dig('choices', 0, 'message', 'content')
  rescue => e
    Rails.logger.error "OpenAI API Error: #{e.message}"
    '申し訳ありません。アドバイスの生成に失敗しました。'
  end
end
