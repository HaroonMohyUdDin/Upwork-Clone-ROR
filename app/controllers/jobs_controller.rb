class JobsController < ApplicationController
  before_action :authenticate_user!, except: [:index, :show]
  before_action :set_job, only: [:show, :edit, :update, :destroy, :close]
  before_action :authorize_job_owner!, only: [:edit, :update, :destroy, :close]

  # List all jobs (public view)
  def index
  @jobs = Job.open_jobs.recent
  
  # Apply filters
  @jobs = @jobs.where(category: params[:category]) if params[:category].present?
  @jobs = @jobs.where("budget >= ?", params[:min_budget]) if params[:min_budget].present?
  @jobs = @jobs.where("budget <= ?", params[:max_budget]) if params[:max_budget].present?
  
  @jobs = @jobs.limit(12)
end

  # Show job details with proposals
  def show
    @proposals = @job.proposals.includes(:user).order(created_at: :desc)
    @proposal_count = @proposals.count
    @accepted_proposal = @proposals.find_by(status: :accepted)
  end

  # New job form (CLIENT ONLY)
  def new
    authorize_client!
    @job = current_user.jobs.build
  end

  # Create new job (CLIENT ONLY)
  def create
    authorize_client!
    @job = current_user.jobs.build(job_params)
    
    if @job.save
      redirect_to @job, notice: 'Job posted successfully! Wait for freelancers to submit proposals.'
    else
      render :new, status: :unprocessable_entity
    end
  end

  # Edit job (CLIENT ONLY)
  def edit
    authorize_client!
  end

  # Update job (CLIENT ONLY)
  def update
    authorize_client!
    
    if @job.update(job_params)
      redirect_to @job, notice: 'Job updated successfully'
    else
      render :edit, status: :unprocessable_entity
    end
  end

def close
  authorize_job_owner!
  
  if @job.update(status: :closed)
    redirect_to @job, notice: "Job closed successfully"
  else
    redirect_to @job, alert: "Error closing job"
  end
end

def destroy
  authorize_job_owner!
  
  @job.destroy
  redirect_to client_dashboard_path, notice: "Job deleted successfully"
rescue StandardError => e
  redirect_to @job, alert: "Unable to delete job: #{e.message}"
end
  private

  def set_job
    @job = Job.find(params[:id])
  end

 private

  def job_params
    params.require(:job).permit(:title, :description, :budget, :category, :deadline, :status)
  end

  def authorize_job_owner!
    redirect_to root_path, alert: 'Not authorized' unless @job.user == current_user
  end

  def authorize_client!
    redirect_to root_path, alert: 'Only clients can post jobs' unless current_user&.client?
  end
end