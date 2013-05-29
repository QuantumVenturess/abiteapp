module SeatsHelper

  include ApplicationHelper

  def seat_to_json(seat)
    hash = {
      created_at: nsdate_format(seat.created_at),
      id: seat.id,
      table: seat.table.attributes,
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

end