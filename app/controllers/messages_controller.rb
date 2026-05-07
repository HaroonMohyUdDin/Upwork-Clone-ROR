class MessagesController < ApplicationController
  before_action :authenticate_user!
  before_action :set_conversation
  before_action :authorize_participant!

  def create
    @message = @conversation.messages.build(content: message_params[:content])
    assign_sender_and_receiver!(@message)

    if @message.save
      @conversation.touch
      redirect_to conversation_path(@conversation), notice: "Message sent"
    else
      redirect_to conversation_path(@conversation), alert: @message.errors.full_messages.to_sentence
    end
  end

  private

  def set_conversation
    @conversation = Conversation.find(params[:conversation_id])
  end

  def authorize_participant!
    participants = [@conversation.sender_id, @conversation.receiver_id]
    unless participants.include?(current_user.id)
      redirect_to conversations_path, alert: "You are not authorized to send messages in this conversation."
    end
  end

  def assign_sender_and_receiver!(message)
    message.sender = current_user
    message.receiver = other_participant
  end

  def other_participant
    @conversation.sender_id == current_user.id ? @conversation.receiver : @conversation.sender
  end

  def message_params
    params.require(:message).permit(:content)
  end
end