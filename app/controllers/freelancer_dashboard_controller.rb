class FreelancerDashboardController < ApplicationController
  before_action :authenticate_user!
  before_action :authorize_freelancer!

  def index
    @freelancer = current_user
    @skills = @freelancer.skills || []
    @contracts = @freelancer.contracts_as_freelancer.where(status: 'active')
    @reviews = @freelancer.reviews_as_reviewee.limit(5)
    
      # Additional dashboard data
      @total_earned = @freelancer.payments.completed_payments.sum(:amount)
      @proposals_count = @freelancer.proposals.count
      @pending_proposals_count = @freelancer.proposals.where(status: :pending).count
      @accepted_proposals_count = @freelancer.proposals.where(status: :accepted).count
      @all_contracts_count = @freelancer.contracts_as_freelancer.count
      @unread_messages_count = @freelancer.received_messages.where(read: false).count
      @total_reviews = @freelancer.reviews_as_reviewee.count
  end


  def edit_profile
    @freelancer = current_user
  end

  def update_profile
    @freelancer = current_user

    if @freelancer.update(freelancer_params)
      redirect_to freelancer_dashboard_path, notice: 'Profile updated successfully'
    else
      render :edit_profile
    end
  end

  private

  def freelancer_params
    params.require(:user).permit(:name, :bio, :hourly_rate, :hours_per_week, :profile_picture)
  end

  def authorize_freelancer!
    redirect_to root_path, alert: 'Not authorized' unless current_user.freelancer?
  end
end