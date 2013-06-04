module TablesHelper

  include ApplicationHelper
  include SeatsHelper

  def table_description(table)
    ["Join #{table.user.first_name}", 
      "and #{view_context.pluralize(table.max_seats - 1, 'other')}", 
      "at #{table.place.name}",
      "on #{table.start_date.strftime('%B %-d, %Y')}"].join(' ')
  end

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
      array.append(hash)
    end
    array
  end

end