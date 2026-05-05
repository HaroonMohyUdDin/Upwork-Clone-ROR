class Proposal < ApplicationRecord
 
  belongs_to :job       # Proposal belongs to a job
  belongs_to :user      # Proposal by a freelancer (user)
  has_one :contract, dependent: :destroy  # If accepted, creates contract

  # ===== ENUMS =====
  enum :status, { pending: 0, accepted: 1, rejected: 2 }
  # ===== VALIDATIONS =====
  validates :cover_letter, presence: true
  validates :job_id, presence: true
  validates :user_id, presence: true
  validate :freelancer_cannot_propose_own_job

  # ===== HELPER METHODS =====
  def freelancer_cannot_propose_own_job
    if job.user_id == user_id
      errors.add(:base, "You cannot propose on your own job")
    end
  end
end

