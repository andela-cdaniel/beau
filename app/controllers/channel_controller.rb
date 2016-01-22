class ChannelController < ApplicationController
  before_action :login_required

  def index
    @messages = Message.message_group
  end

  def conversation
    user = User.find_by_username conversation_param[:username]

    if user
      @receiver = user
      @messages = Conversation.direct_messages(current_user.id, @receiver.id)

      render :conversation
    else
      redirect_to channel_path
    end
  end

  private def conversation_param
    params.permit(:username)
  end
end
