class Conversation < ApplicationRecord
  belongs_to :sender, class_name: 'User'      # User who started conversation
  belongs_to :receiver, class_name: 'User'    # Other user
  has_many :messages, dependent: :destroy     # Messages in conversation

  # ===== VALIDATIONS =====
  validates :sender_id, presence: true
  validates :receiver_id, presence: true

end
