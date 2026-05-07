class Contract < ApplicationRecord
  belongs_to :job
  belongs_to :proposal
  belongs_to :freelancer, class_name: 'User'
  belongs_to :client, class_name: 'User'

  enum :status, { active: 0, completed: 1, cancelled: 2 }

  validates :job_id, presence: true
  validates :proposal_id, presence: true
  validates :freelancer_id, presence: true
  validates :client_id, presence: true
  validates :status, presence: true

  scope :active_contracts, -> { where(status: :active) }
  scope :completed_contracts, -> { where(status: :completed) }
  scope :cancelled_contracts, -> { where(status: :cancelled) }
end
