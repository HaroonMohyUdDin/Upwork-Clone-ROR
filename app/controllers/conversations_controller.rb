class ConversationsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_conversation, only: [:show]
  before_action :authorize_participant!, only: [:show]

  def index
    @conversations = Conversation
      .where("sender_id = :id OR receiver_id = :id", id: current_user.id)
      .includes(:sender, :receiver)
      .order(updated_at: :desc)
  end

  def show
    @messages = @conversation.messages.includes(:sender, :receiver).order(created_at: :asc)
    @message = Message.new
  end

  def create
    receiver = User.find(params[:receiver_id])

    if receiver == current_user
      redirect_to conversations_path, alert: "You cannot start a conversation with yourself." and return
    end

    @conversation = find_between_users(current_user.id, receiver.id)

    unless @conversation
      @conversation = Conversation.create!(sender: current_user, receiver: receiver)
    end

    redirect_to conversation_path(@conversation)
  rescue ActiveRecord::RecordNotFound
    redirect_to conversations_path, alert: "User not found."
  rescue ActiveRecord::RecordInvalid => e
    redirect_to conversations_path, alert: "Could not create conversation: #{e.record.errors.full_messages.to_sentence}"
  end

  private

  def set_conversation
    @conversation = Conversation.find(params[:id])
  end

  def authorize_participant!
    is_participant = [@conversation.sender_id, @conversation.receiver_id].include?(current_user.id)
    redirect_to conversations_path, alert: "Not authorized to view this conversation." unless is_participant
  end

  def find_between_users(user_a_id, user_b_id)
    Conversation.find_by(sender_id: user_a_id, receiver_id: user_b_id) ||
      Conversation.find_by(sender_id: user_b_id, receiver_id: user_a_id)
  end
end