class Contract < ApplicationRecord
  belongs_to :job              # Contract is for a job
  belongs_to :proposal         # Contract based on proposal
  belongs_to :freelancer, class_name: 'User'  # Freelancer in contract
  belongs_to :client, class_name: 'User'      # Client in contract

  # ===== ENUMS =====
  enum :status, { active: 0, completed: 1, cancelled: 2 }
  # ===== VALIDATIONS =====
  validates :job_id, presence: true
  validates :proposal_id, presence: true
  validates :freelancer_id, presence: true
  validates :client_id, presence: true
  validates :status, presence: true
end
