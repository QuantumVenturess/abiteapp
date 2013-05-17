module TablesHelper

  def tables_to_json(tables)
    array = []
    tables.each do |table|
      hash = {
        complete: table.complete,
        created_at: table.created_at,
        date_complete: table.date_complete,
        date_ready: table.date_ready,
        id: table.id,
        max_seats: table.max_seats,
        place: table.place.attributes,
        place_id: table.place_id,
        ready: table.ready,
        seats: table.seats,
        updated_at: table.updated_at,
        user_id: table.user_id
      }
      array.append(hash)
    end
    array
  end

end