class DailiesController < ApplicationController
  before_action :set_chat, only: [:new, :create]

  def new
    @last_message = @chat.messages.order(created_at: :desc).first
    
    default_title = "Daily du #{Time.zone.now.strftime('%d/%m/%Y')} - Résumé de l'actualité"
    
    @daily = Daily.new(
      summary: @last_message&.content,
      title: default_title
    )
  end

  def create
    @daily = Daily.new(daily_params)
    
    if @daily.save
      # On déplace le chat vers ce nouveau daily
      @chat.daily = @daily
      @chat.save
      
      redirect_to @daily, notice: "Nouveau Daily créé et associé."
    else
      @last_message = @chat.messages.order(created_at: :desc).first
      render :new, status: :unprocessable_entity
    end
  end

  private

  def set_chat
    @chat = Chat.find(params[:chat_id])
  end

  def daily_params
    # On autorise :summary et :title
    params.require(:daily).permit(:summary, :title)
  end
end
