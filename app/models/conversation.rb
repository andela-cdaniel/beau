class Conversation < ActiveRecord::Base
  belongs_to :sender, class_name: "User"
  belongs_to :receiver, class_name: "User"

  def self.direct_messages(sender_id, receiver_id)
    where(sender_id: [sender_id, receiver_id]).
    where(receiver_id: [sender_id, receiver_id]).
    order(created_at: :desc).
    group_by { |obj| obj.created_at.beginning_of_day }
  end
end
