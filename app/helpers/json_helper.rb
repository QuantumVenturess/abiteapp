module JsonHelper

  include ApplicationHelper

  def message_to_json(message)
    hash = {
      content: message.content,
      created_at: nsdate_format(message.created_at),
      id: message.id,
      table: table_to_json(message.table),
      table_id: message.table.id,
      updated_at: nsdate_format(message.updated_at),
      user: message.user.attributes,
      user_id: message.user.id
    }
  end

  def messages_to_json(messages)
    array = []
    messages.each do |message|
      hash = {
        content: message.content,
        created_at: nsdate_format(message.created_at),
        id: message.id,
        table: message.table.attributes,
        table_id: message.table.id,
        updated_at: nsdate_format(message.updated_at),
        user: message.user.attributes,
        user_id: message.user.id
      }
      array.append(hash)
    end
    array
  end

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

  def seat_to_json(seat)
    hash = {
      created_at: nsdate_format(seat.created_at),
      id: seat.id,
      table: table_to_json(seat.table),
      table_id: seat.table_id,
      updated_at: nsdate_format(seat.updated_at),
      user: seat.user.attributes,
      user_id: seat.user_id
    }
  end

  def seats_to_json(seats)
    array = []
    seats.each do |seat|
      hash = {
        created_at: nsdate_format(seat.created_at),
        id: seat.id,
        table: seat.table.attributes,
        table_id: seat.table_id,
        updated_at: nsdate_format(seat.updated_at),
        user: seat.user.attributes,
        user_id: seat.user_id
      }
      array.append(hash)
    end
    array
  end

  def table_to_json(table)
    hash = {
      complete: table.complete,
      created_at: nsdate_format(table.created_at),
      date_complete: nsdate_format(table.date_complete),
      date_ready: nsdate_format(table.date_ready),
      id: table.id,
      max_seats: table.max_seats,
      place: table.place.attributes,
      place_id: table.place_id,
      ready: table.ready,
      seats: seats_to_json(table.seats.order('created_at ASC')),
      start_date: nsdate_format(table.start_date),
      updated_at: nsdate_format(table.updated_at),
      user: table.user.attributes,
      user_id: table.user_id
    }
  end

  def tables_to_json(tables)
    array = []
    tables.each do |table|
      array.append(table_to_json(table))
    end
    array
  end

end