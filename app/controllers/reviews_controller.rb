class ReviewsController < ApplicationController
  before_action :authenticate_user!
  before_action :authorize_client!

  # New review form
  def new
    @contract = Contract.find(params[:contract_id])
    @review = Review.new
  end

  # Create review (CLIENT ONLY)
  def create
    @contract = Contract.find(review_params[:contract_id])
    @review = Review.new(review_params)
    @review.reviewer = current_user
    @review.reviewee = @contract.freelancer
    @review.job = @contract.job

    if @review.save
      redirect_to client_dashboard_path, notice: 'Review submitted successfully!'
    else
      render :new, status: :unprocessable_entity
    end
  end

  # View all reviews given by this client
  def my_reviews
    @reviews = Review.where(reviewer_id: current_user.id)
      .includes(:reviewee, :job)
      .order(created_at: :desc)
      .page(params[:page])
      .per(20)
  end

  private

  def review_params
    params.require(:review).permit(:contract_id, :rating, :comment)
  end

  def authorize_client!
    redirect_to root_path, alert: 'Only clients can review' unless current_user&.client?
  end
end