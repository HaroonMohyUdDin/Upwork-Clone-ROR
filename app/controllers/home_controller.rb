class HomeController < ApplicationController
  def index
    @jobs = []
    
    if user_signed_in?
      if current_user.freelancer?
        redirect_to freelancer_dashboard_path
      elsif current_user.client?
        redirect_to client_dashboard_path
      end
    else
      @jobs = Job.open_jobs.recent.limit(8)
    end
  end
end