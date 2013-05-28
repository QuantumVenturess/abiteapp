class UserMailer < ActionMailer::Base
  default from: 'Bite hello@abiteapp.com'

  def table_ready(table, user)
    @table = table
    @seats = table.seats.order('created_at ASC')
    if Rails.env.production?
      @root_url = 'http://abiteapp.com'
    else
      if ENV['os'] == 'Windows_NT'
        @root_url = 'http://localhost:3000'
      else
        @root_url = 'http://192.168.1.72:3000'
      end
    end
    @table_url = "#{@root_url}#{url_for(@table)}"
    email_with_name = "#{user.name} <#{user.email}>"
    mail(to: email_with_name, 
         subject: "Your table at #{table.place.name} is ready", 
         content_type: 'text/html')
  end
end
