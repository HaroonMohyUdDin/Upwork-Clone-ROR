class ProposalsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_job, only: [:index, :create]
  before_action :set_proposal, only: [:show, :accept, :reject]

  def index
    if @job
      @proposals = @job.proposals.includes(:user)
    else
      # Show all proposals submitted by current user
      @proposals = current_user.proposals.includes(:job).order(created_at: :desc)
    end
  end

  def show
  end

  def create
    @proposal = @job.proposals.build(proposal_params)
    @proposal.user = current_user
    
    if @proposal.save
      redirect_to @job, notice: 'Proposal submitted successfully'
    else
      redirect_to @job, alert: 'Error submitting proposal'
    end
  end

  def accept
    unless current_user == @proposal.job.user
      redirect_to @proposal, alert: 'Only the job owner can accept proposals' and return
    end

    begin
      ActiveRecord::Base.transaction do
        @proposal.update!(status: 'accepted')
        @contract = Contract.create!(
          freelancer_id: @proposal.user_id,
          client_id: @proposal.job.user_id,
          job_id: @proposal.job_id,
          proposal_id: @proposal.id,
          status: 'active'
        )
      end
      redirect_to contract_path(@contract), notice: 'Proposal accepted and contract created'
    rescue => e
      redirect_to @proposal, alert: "Unable to accept proposal: #{e.message}"
    end
  end

  def reject
    unless current_user == @proposal.job.user
      redirect_to @proposal, alert: 'Only the job owner can reject proposals' and return
    end

    if @proposal.update(status: 'rejected')
      redirect_to @proposal, notice: 'Proposal rejected'
    else
      redirect_to @proposal, alert: 'Unable to reject proposal'
    end
  end

  private

  def set_job
    @job = Job.find(params[:job_id])
  end

  def set_proposal
    @proposal = Proposal.find(params[:id])
  end

  def proposal_params
    params.require(:proposal).permit(:cover_letter)
  end
end
