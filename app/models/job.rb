class Job < ApplicationRecord
  belongs_to :user
  has_many :proposals, dependent: :destroy   # Job has many proposals from freelancers
  has_many :contracts, dependent: :destroy   # Job has contracts
  has_many :messages, dependent: :destroy    # Messages related to job
  has_many :reviews, dependent: :destroy     # Reviews for job
  has_many :payments, dependent: :destroy    # Payments for job

  # ===== ENUMS =====
  enum :status, { open: 0, in_progress: 1, closed: 2 }
  # ===== VALIDATIONS =====
  validates :title, presence: true
  validates :description, presence: true
  validates :budget, presence: true, numericality: { greater_than: 0 }
  validates :category, presence: true
  validates :user_id, presence: true
  validates :status, presence: true

  scope :open_jobs, -> { where(status: :open) }
  scope :by_category, ->(category) { where(category: category) if category.present? }
  scope :recent, -> { order(created_at: :desc) }
end
