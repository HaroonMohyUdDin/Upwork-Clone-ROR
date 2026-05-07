class ProposalsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_job, only: [:index, :create]
  before_action :set_proposal, only: [:show, :accept, :reject, :message_freelancer]
  before_action :authorize_job_owner!, only: [:accept, :reject, :message_freelancer]

  def index
    if @job
      @proposals = @job.proposals.includes(:user).order(created_at: :desc)
    else
      @proposals = current_user.proposals.includes(:job).order(created_at: :desc)
    end
  end

  def show
  end

  def create
    @proposal = @job.proposals.build(proposal_params)
    @proposal.user = current_user
    @proposal.status = :pending

    if @proposal.save
      redirect_to @job, notice: "Proposal submitted successfully"
    else
      redirect_to @job, alert: "Error submitting proposal"
    end
  end

  def accept
    ActiveRecord::Base.transaction do
      @proposal.update!(status: :accepted)

      @contract = Contract.find_or_create_by!(proposal: @proposal) do |contract|
        contract.job = @proposal.job
        contract.freelancer = @proposal.user
        contract.client = @proposal.job.user
        contract.status = :active
      end
    end

    redirect_to contract_path(@contract), notice: "Proposal accepted and contract created"
  rescue StandardError => e
    redirect_to @proposal, alert: "Unable to accept proposal: #{e.message}"
  end

  def reject
    if @proposal.update(status: :rejected)
      redirect_to @proposal, notice: "Proposal rejected"
    else
      redirect_to @proposal, alert: "Unable to reject proposal"
    end
  end

  def message_freelancer
    freelancer = @proposal.user

    conversation = Conversation.find_or_create_by(
      sender: current_user,
      receiver: freelancer
    )

    message = conversation.messages.build(
      sender: current_user,
      receiver: freelancer,
      content: "Hi #{freelancer.name}, I’d like to discuss your proposal for #{@proposal.job.title}."
    )

    if message.save
      redirect_to conversation_path(conversation), notice: "Message sent"
    else
      redirect_to @proposal, alert: "Unable to send message"
    end
  end

  private

  def set_job
    @job = Job.find(params[:job_id])
  end

  def set_proposal
    @proposal = Proposal.find(params[:id])
  end

  def authorize_job_owner!
    redirect_to @proposal, alert: "Only the job owner can perform this action" unless current_user == @proposal.job.user
  end

  def proposal_params
    params.require(:proposal).permit(:cover_letter)
  end
end