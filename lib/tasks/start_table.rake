desc 'Start Table'
task start_table: :environment do
  require 'rubygems'
  start_table
end

def start_table
  # Randomly choose a place to eat
  place = Place.order('RANDOM()').first
  # Randomly choose the users who will sit at the table
  if Rails.env.production?
    user_ids = [4, 7, 10, 31, 33, 35, 43, 44, 45, 48]
    # Randomly choose the number of seats at the table (2 - 10)
    max_seats = (2..user_ids.size).to_a.sample
    # Shuffle and randomize the pool of users who will sit at the table
    new_user_ids = user_ids.shuffle[0, max_seats]
    users = []
    new_user_ids.each do |id|
      users.append(User.find(id))
    end
  else
    users = User.limit(10)
    # Randomly choose the number of seats at the table (2 - 3)
    max_seats = (2..users.size).to_a.sample
    # Shuffle and randomize the pool of users who will sit at the table
    users = users.shuffle[0, max_seats]
  end
  # Create the table at place
  table = Table.new
  table.max_seats  = max_seats + 5
  table.place      = place
  table.start_date = Time.zone.now + 1.hour
  table.user       = users[0]
  table.save
  # Create a seat for each user
  users.each do |user|
    seat       = Seat.new
    seat.table = table
    seat.user  = user
    seat.save
  end
end