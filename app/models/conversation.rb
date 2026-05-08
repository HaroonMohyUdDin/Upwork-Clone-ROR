class Conversation < ApplicationRecord
  belongs_to :client, class_name: 'User'
  belongs_to :freelancer, class_name: 'User'
  has_many :messages, dependent: :destroy

  validates :client_id, :freelancer_id, presence: true
  validates :freelancer_id, uniqueness: { scope: :client_id }

  validate :client_must_have_client_role
  validate :freelancer_must_have_freelancer_role

  scope :for_user, ->(user) { where("client_id = :id OR freelancer_id = :id", id: user.id) }

  def self.between(client, freelancer)
    find_by(client: client, freelancer: freelancer)
  end

  def participant?(user)
    client_id == user.id || freelancer_id == user.id
  end

  def other_party(user)
    user.id == client_id ? freelancer : client
  end

  private

  def client_must_have_client_role
    return if client&.client?

    errors.add(:client, "must have client role")
  end

  def freelancer_must_have_freelancer_role
    return if freelancer&.freelancer?

    errors.add(:freelancer, "must have freelancer role")
  end
end