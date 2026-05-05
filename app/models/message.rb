class Message < ApplicationRecord
  belongs_to :sender, class_name: 'User'      # Who sent the message
  belongs_to :receiver, class_name: 'User'    # Who received the message
  belongs_to :conversation                     # Which conversation

  # ===== VALIDATIONS =====
  validates :content, presence: true
  validates :sender_id, presence: true
  validates :receiver_id, presence: true
  validates :conversation_id, presence: true
end
