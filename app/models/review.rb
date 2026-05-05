class Review < ApplicationRecord
  belongs_to :reviewer, class_name: 'User'   # Who wrote the review
  belongs_to :reviewee, class_name: 'User'   # Who is being reviewed
  belongs_to :job                             # Review about a job

  # ===== VALIDATIONS =====
  validates :rating, presence: true, inclusion: { in: 1..5 }
  validates :reviewer_id, presence: true
  validates :reviewee_id, presence: true
  validates :job_id, presence: true
  validate :cannot_review_own_work
  validate :cannot_review_same_person_twice

  # ===== HELPER METHODS =====

  def cannot_review_own_work
    if reviewer_id == reviewee_id
      errors.add(:base, "You cannot review your own work")
    end
  end

  def cannot_review_same_person_twice
    # Check if review already exists
    if Review.where(reviewer_id: reviewer_id, reviewee_id: reviewee_id, job_id: job_id).exists?
      errors.add(:base, "You already reviewed this person for this job")
    end
  end
end