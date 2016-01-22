class Message < ActiveRecord::Base
  belongs_to :user

  validates :comment, presence: true

  def self.message_group
    all.order(created_at: :desc).group_by do |obj|
      obj.created_at.beginning_of_day
    end
  end
end
