class Proposal < ApplicationRecord
  belongs_to :job
  belongs_to :user
  has_one :contract, dependent: :destroy

  enum :status, { pending: 0, accepted: 1, rejected: 2 }, default: :pending

  validates :cover_letter, presence: true
  validates :job_id, presence: true
  validates :user_id, presence: true
  validate :freelancer_cannot_propose_own_job

  def freelancer_cannot_propose_own_job
    if job.present? && job.user_id == user_id
      errors.add(:base, "You cannot propose on your own job")
    end
  end
end