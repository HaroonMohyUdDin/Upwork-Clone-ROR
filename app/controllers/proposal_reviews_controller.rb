class ProposalReviewsController < ApplicationController
  before_action :authenticate_user!
  before_action :authorize_client!
  before_action :set_job
  before_action :set_proposal

  # Accept a proposal (CLIENT ONLY)
  def accept
    if @proposal.update(status: :accepted)
      # Create contract
      Contract.create(
        job_id: @job.id,
        proposal_id: @proposal.id,
        freelancer_id: @proposal.user_id,
        client_id: current_user.id,
        status: :active
      )

      redirect_to @job, notice: 'Proposal accepted! Contract created.'
    else
      redirect_to @job, alert: 'Error accepting proposal'
    end
  end

  # Reject a proposal (CLIENT ONLY)
  def reject
    if @proposal.update(status: :rejected)
      redirect_to @job, notice: 'Proposal rejected'
    else
      redirect_to @job, alert: 'Error rejecting proposal'
    end
  end

  # Send message to freelancer (CLIENT ONLY)
  def message_freelancer
    freelancer = @proposal.user
    conversation = Conversation.get_or_create(current_user.id, freelancer.id)
    redirect_to conversation_path(conversation), notice: 'Chat opened'
  end

  private

  def set_job
    @job = Job.find(params[:job_id])
    authorize_job_owner!
  end

  def set_proposal
    @proposal = @job.proposals.find(params[:proposal_id])
  end

  def authorize_client!
    redirect_to root_path, alert: 'Not authorized' unless current_user&.client?
  end

  def authorize_job_owner!
    redirect_to root_path, alert: 'Not authorized' unless @job.user == current_user
  end
end