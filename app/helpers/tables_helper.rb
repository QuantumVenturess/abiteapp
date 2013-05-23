module TablesHelper

  include ApplicationHelper
  include SeatsHelper

  def random_start_date
    r = Random.new
    i = r.rand(0..3)
    statements = [
      'Time and date open for discussion',
      'Let\'s go before the world ends',
      'Let\'s get together before we grow old',
      'Time and date to be announced'
      ];
    statements[i];
  end

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
        seats: seats_to_json(table.seats),
        start_date: nsdate_format(table.start_date),
        updated_at: nsdate_format(table.updated_at),
        user_id: table.user_id
      }
      array.append(hash)
    end
    array
  end

end