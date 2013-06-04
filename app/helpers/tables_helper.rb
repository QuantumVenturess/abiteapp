module TablesHelper

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

end