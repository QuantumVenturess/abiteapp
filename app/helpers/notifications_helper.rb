module NotificationsHelper

  include ApplicationHelper
  include MessagesHelper
  include SeatsHelper
  include TablesHelper

  def notifications_to_json(notifications)
    array = []
    notifications.each do |notification|
      hash = {
        created_at: nsdate_format(notification.created_at),
        id: notification.id,
        message_id: notification.message_id,
        seat_id: notification.seat_id,
        table_id: notification.table_id,
        updated_at: nsdate_format(notification.updated_at),
        user: notification.user.attributes,
        user_id: notification.user_id,
        viewed: notification.viewed
      }
      if notification.message
        hash[:message] = message_to_json(notification.message)
      end
      if notification.seat
        hash[:seat] = seat_to_json(notification.seat)
      end
      if notification.table
        hash[:table] = table_to_json(notification.table)
      end
      array.append(hash)
    end
    array
  end

end