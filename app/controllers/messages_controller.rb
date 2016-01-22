class MessagesController < WebsocketRails::BaseController
  def online_users
    WebsocketRails[:messages].trigger(:online, active_users)
  end

  def update_online_users
    WebsocketRails[:messages].trigger(:offline, active_users)
  end

  def create
    new_message = Message.new
    new_message.comment, new_message.user_id = message[:comment], message[:user_id]
    if new_message.save
      WebsocketRails[:messages].trigger(:new, format(new_message))
    else
      send_message :error, new_message.errors.full_messages
    end
  end

  def direct_message
    conversation = Conversation.new
    conversation.message = message[:comment]
    conversation.sender_id = message[:sender]
    conversation.receiver_id = message[:receiver]

    if conversation.save
      send_message :dm, format_dm(conversation)
      WebsocketRails.users[message[:receiver]].send_message :dm, format_dm(conversation)
    else
      send_message :error, conversation.errors.full_messages
    end
  end

  private

  def format(message)
    data = {}
    data[:username] = message.user.username
    data[:comment] = message[:comment]
    data[:time] = message[:created_at].strftime("%l:%M %p").strip
    data
  end

  def format_dm(direct_message)
    data = {}
    data[:sender] = direct_message.sender.username
    data[:comment] = direct_message.message
    data[:time] = direct_message.created_at.strftime("%l:%M %p").strip
    data
  end

  def active_users
    WebsocketRails.users.users.keys.map do |id|
      User.find(id).username
    end
  end
end