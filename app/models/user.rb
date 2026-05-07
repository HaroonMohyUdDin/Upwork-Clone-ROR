class User < ApplicationRecord
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable,
         :confirmable

  # Role as STRING not INTEGER (since schema uses string)
  # No enum - just use string directly
  
  has_many :jobs, dependent: :destroy
  has_many :proposals, dependent: :destroy
  has_many :contracts_as_freelancer, class_name: 'Contract', foreign_key: 'freelancer_id', dependent: :destroy
  has_many :contracts_as_client, class_name: 'Contract', foreign_key: 'client_id', dependent: :destroy
  has_many :sent_messages, class_name: 'Message', foreign_key: 'sender_id', dependent: :destroy
  has_many :received_messages, class_name: 'Message', foreign_key: 'receiver_id', dependent: :destroy
  has_many :reviews_as_reviewer, class_name: 'Review', foreign_key: 'reviewer_id', dependent: :destroy
  has_many :reviews_as_reviewee, class_name: 'Review', foreign_key: 'reviewee_id', dependent: :destroy
  has_many :payments, dependent: :destroy
  has_many :sent_conversations, class_name: 'Conversation', foreign_key: 'sender_id', dependent: :destroy
  has_many :received_conversations, class_name: 'Conversation', foreign_key: 'receiver_id', dependent: :destroy
   has_many :skills, dependent: :destroy  # ADD THIS LINE
  validates :name, presence: true
  validates :email, presence: true, uniqueness: true
  validates :role, presence: true, inclusion: { in: ['freelancer', 'client'], message: "%{value} is not a valid role" }

  def freelancer?
    role == 'freelancer'
  end

  def client?
    role == 'client'
  end

  def average_rating
    return 0 if reviews_as_reviewee.empty?
    reviews_as_reviewee.average(:rating).to_f.round(2)
  end

  def review_count
    reviews_as_reviewee.count
  end
end