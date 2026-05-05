class SkillsController < ApplicationController
  before_action :authenticate_user!
  before_action :authorize_freelancer!
  before_action :set_skill, only: [:edit, :update, :destroy]

  def create
    @skill = current_user.skills.build(skill_params)

    if @skill.save
      redirect_to freelancer_dashboard_path, notice: 'Skill added'
    else
      redirect_to freelancer_dashboard_path, alert: 'Error adding skill'
    end
  end

  def edit
  end

  def update
    if @skill.update(skill_params)
      redirect_to freelancer_dashboard_path, notice: 'Skill updated'
    else
      render :edit
    end
  end

  def destroy
    @skill.destroy
    redirect_to freelancer_dashboard_path, notice: 'Skill deleted'
  end

  private

  def set_skill
    @skill = Skill.find(params[:id])
  end

  def skill_params
    params.require(:skill).permit(:name, :proficiency)
  end

  def authorize_freelancer!
    redirect_to root_path unless current_user.freelancer?
  end
end