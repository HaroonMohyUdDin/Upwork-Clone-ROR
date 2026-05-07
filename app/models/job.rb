class Job < ApplicationRecord
  belongs_to :user
  has_many :proposals, dependent: :destroy
  has_many :contracts, dependent: :destroy
  has_many :reviews, dependent: :destroy
  has_many :payments, dependent: :destroy
  has_many :messages, dependent: :destroy

  validates :title, presence: true
  validates :description, presence: true
  validates :budget, presence: true, numericality: { greater_than: 0 }
  validates :category, presence: true
  validates :status, presence: true, inclusion: { in: ['open', 'in_progress', 'closed'] }

  scope :open_jobs, -> { where(status: 'open') }
  scope :recent, -> { order(created_at: :desc) }

  before_create :set_default_status

  private

  def set_default_status
    self.status ||= 'open'
  end
end