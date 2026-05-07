class Conversation < ApplicationRecord
  belongs_to :sender, class_name: "User"
  belongs_to :receiver, class_name: "User"
  has_many :messages, dependent: :destroy

  validates :sender_id, presence: true
  validates :receiver_id, presence: true
  validate :sender_and_receiver_must_be_different
  validate :pair_must_be_unique_regardless_of_order

  private

  def sender_and_receiver_must_be_different
    return unless sender_id.present? && receiver_id.present?
    errors.add(:receiver_id, "must be different from sender") if sender_id == receiver_id
  end

  def pair_must_be_unique_regardless_of_order
    return unless sender_id.present? && receiver_id.present?

    duplicate_exists = Conversation
      .where(
        "(sender_id = :s AND receiver_id = :r) OR (sender_id = :r AND receiver_id = :s)",
        s: sender_id, r: receiver_id
      )
      .where.not(id: id)
      .exists?

    errors.add(:base, "Conversation already exists between these users") if duplicate_exists
  end
end