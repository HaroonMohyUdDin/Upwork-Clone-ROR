class Message < ApplicationRecord
  belongs_to :conversation
  belongs_to :sender, class_name: "User"
  belongs_to :receiver, class_name: "User", optional: true

  validates :body, presence: true, length: { maximum: 2000 }
  validate :sender_must_be_conversation_participant

  scope :ordered, -> { order(:created_at) }

  def mark_as_read
    update(read: true)
  end

  private

  def sender_must_be_conversation_participant
    return if conversation&.participant?(sender)

    errors.add(:sender, "must be part of this conversation")
  end
end