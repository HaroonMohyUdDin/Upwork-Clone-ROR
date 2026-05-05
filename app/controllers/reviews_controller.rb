class ReviewsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_job, only: [:new, :create]

  def new
    @review = @job.reviews.build
  end

  def create
    @review = @job.reviews.build(review_params)
    @review.reviewer = current_user
    
    if @review.save
      redirect_to @job, notice: 'Review submitted successfully'
    else
      render :new, status: :unprocessable_entity
    end
  end

  private

  def set_job
    @job = Job.find(params[:job_id])
  end

  def review_params
    params.require(:review).permit(:rating, :comment, :reviewee_id)
  end
end
