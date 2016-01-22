class User < ActiveRecord::Base
  has_many :messages
  has_many :sent, class_name: "Conversation", foreign_key: "sender_id"
  has_many :received, class_name: "Conversation", foreign_key: "receiver_id"
  has_secure_password

  before_save { self.username = username.downcase }

  validates :username,
            presence: true,
            uniqueness: { case_sensitive: false },
            format: { with: /\A[A-z0-9]+\z/ },
            length: { minimum: 3 }

  validates :password,
            presence: true,
            length: { minimum: 8 }
end
