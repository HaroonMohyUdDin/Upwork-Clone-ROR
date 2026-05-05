class Payment < ApplicationRecord
  belongs_to :user  # User who paid
  belongs_to :job   # Job being paid for

  #  ENUMS 
  enum :status, { pending: 0, completed: 1, failed: 2 }
  #  VALIDATIONS 
  validates :amount, presence: true, numericality: { greater_than: 0 }
  validates :user_id, presence: true
  validates :job_id, presence: true
  validates :status, presence: true
  
    # ===== SCOPES =====
    scope :completed_payments, -> { where(status: :completed) }
end
