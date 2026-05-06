class ClientDashboardController < ApplicationController
  before_action :authenticate_user!
  before_action :authorize_client!

  def index
    @client = current_user
    @jobs = @client.jobs.order(created_at: :desc)
    @active_jobs = @client.jobs.where(status: :in_progress)
    @completed_jobs = @client.jobs.where(status: :closed)
    @total_spent = @client.payments.sum(:amount) rescue 0
    @pending_proposals = Proposal.joins(:job).where(jobs: { user_id: @client.id }, proposals: { status: :pending }).count
    @active_contracts = Contract.where(client_id: @client.id, status: :active).count
    @month_spent = @client.payments.where(created_at: Time.current.beginning_of_month..Time.current.end_of_month).sum(:amount) rescue 0
  end

  def job_proposals
    @job = current_user.jobs.find(params[:job_id])
    @proposals = @job.proposals.includes(:user).order(created_at: :desc)
  end

  def contracts
    @contracts = Contract.where(client_id: current_user.id, status: :active)
      .includes(:freelancer, :job)
      .order(created_at: :desc)
  end

  def payments
    @payments = current_user.payments.order(created_at: :desc)
  end

  def freelancers
    @freelancers = User.where(role: 'freelancer')
      .includes(:reviews_as_reviewee)
  end

  private

  def authorize_client!
    redirect_to root_path, alert: 'Only clients can access this' unless current_user.role == 'client'
  end
end