class JobsController < ApplicationController
  before_action :authenticate_user!, except: [:index, :show]
  before_action :set_job, only: [:show, :edit, :update, :destroy]

  def index
    @jobs = Job.open_jobs.recent
  end

  def show
    @proposals = @job.proposals
  end

  def new
    @job = Job.new
  end

  def create
    @job = current_user.jobs.build(job_params)
    if @job.save
      redirect_to @job, notice: 'Job posted successfully'
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit
  end

  def update
    if @job.update(job_params)
      redirect_to @job, notice: 'Job updated successfully'
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @job.destroy
    redirect_to jobs_url, notice: 'Job deleted successfully'
  end

  private

  def set_job
    @job = Job.find(params[:id])
  end

  def job_params
    params.require(:job).permit(:title, :description, :budget, :category, :deadline)
  end
end