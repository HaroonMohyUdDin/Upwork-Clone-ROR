class Job < ApplicationRecord
  belongs_to :user
  has_many :proposals, dependent: :destroy
  has_many :contracts, dependent: :destroy
  has_many :reviews, dependent: :destroy

  validates :title, presence: true
  validates :description, presence: true
  validates :budget, presence: true, numericality: { greater_than: 0 }
  validates :category, presence: true
  validates :status, presence: true, inclusion: { in: %w[open in_progress closed] }

  scope :open_jobs, -> { where(status: 'open') }
  scope :recent, -> { order(created_at: :desc) }
end