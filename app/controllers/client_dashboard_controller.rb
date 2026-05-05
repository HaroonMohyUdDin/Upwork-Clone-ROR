class ClientDashboardController < ApplicationController
  before_action :authenticate_user!
  before_action :authorize_client!

  def index
    @client = current_user
    @jobs = @client.jobs.recent
    @active_jobs = @client.jobs.where(status: :in_progress)
    @completed_jobs = @client.jobs.where(status: :closed)
    @total_spent = @client.payments.completed_payments.sum(:amount)
  end
end