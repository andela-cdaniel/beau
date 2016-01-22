class RenameConversationToMessage < ActiveRecord::Migration
  def change
    rename_column :conversations, :conversation, :message
  end
end
