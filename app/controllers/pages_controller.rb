class PagesController < ApplicationController

  def about
    @title = 'About'
  end

  def test
    @table = Table.find(57)
    @seats = @table.seats.order('created_at ASC')
    if Rails.env.production?
      @root_url = 'http://abiteapp.com'
    else
      @root_url = 'http://localhost:3000'
    end
    @room_url = "#{@root_url}#{url_for(room_path(@table.room))}"
    render layout: false
  end

end
