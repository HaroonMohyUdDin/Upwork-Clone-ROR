class AddStatusDefaultToJobs < ActiveRecord::Migration[8.1]
  def change
    change_column_default :jobs, :status, from: nil, to: 'open'
    
    # Set existing jobs to 'open' if status is nil
    Job.where(status: nil).update_all(status: 'open')
  end
end