class ConversationsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_collections, only: [:index, :show]
  before_action :set_conversation, only: [:show]

  def index
    @conversation = find_selected_conversation
  end

  def show
    unless @conversation.participant?(current_user)
      redirect_to conversations_path, alert: "You are not allowed to view this conversation."
      return
    end

    @messages = @conversation.messages.includes(:sender).order(created_at: :asc)
    @message = Message.new
  end

 
  def create
  unless current_user.client?
    redirect_to conversations_path, alert: "Only clients can start conversations."
    return
  end

  freelancer = User.find(params[:freelancer_id])

  unless freelancer.freelancer?
    redirect_to conversations_path, alert: "You can only start conversations with freelancers."
    return
  end

  @conversation = Conversation.find_or_create_by!(
    client_id: current_user.id,
    freelancer_id: freelancer.id
  )

  redirect_to conversation_path(@conversation)
end

private

def set_collections
  @conversations = Conversation.for_user(current_user)
    .includes(messages: :sender)
    .order(updated_at: :desc)

  @freelancers = current_user.client? ? User.where(role: 'freelancer').order(:name) : []
end

def set_conversation
  @conversation = Conversation.find(params[:id])
end

def find_selected_conversation
  return if params[:conversation_id].blank?

  conversation = Conversation.find_by(id: params[:conversation_id])
  return unless conversation&.participant?(current_user)

  conversation
end
end