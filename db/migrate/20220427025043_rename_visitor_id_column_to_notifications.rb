class RenameVisitorIdColumnToNotifications < ActiveRecord::Migration[6.1]
  def change
    rename_column :notifications, :visitor_id, :visiter_id
  end
end
