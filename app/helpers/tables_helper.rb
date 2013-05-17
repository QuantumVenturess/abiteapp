module TablesHelper

  include ApplicationHelper

  def tables_to_json(tables)
    array = []
    tables.each do |table|
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
        seats: table.seats,
        updated_at: nsdate_format(table.updated_at),
        user_id: table.user_id
      }
      array.append(hash)
    end
    array
  end

end