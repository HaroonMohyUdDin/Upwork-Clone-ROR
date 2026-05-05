class ConversationsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_conversation, only: [:show]

  def index
    @conversations = Conversation.where("sender_id = ? OR receiver_id = ?", current_user.id, current_user.id).includes(:sender, :receiver).order(updated_at: :desc)
  end

  def show
    @messages = @conversation.messages.order(created_at: :asc)
    @message = Message.new
  end

  def create
    receiver = User.find(params[:receiver_id])
    @conversation = Conversation.find_or_create_by(sender_id: current_user.id, receiver_id: receiver.id)
    redirect_to @conversation
  end

  private

  def set_conversation
    @conversation = Conversation.find(params[:id])
  end
end
