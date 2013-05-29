class SeatsController < ApplicationController
  before_filter :authenticate

  def explore
    @title  = @nav_title = 'Explore'
    @tables = current_user.tables_not_sitting.page(params[:p])
    respond_to do |format|
      format.html
      format.js
      format.json {
        hash = {
          pages: @tables.num_pages,
          tables: tables_to_json(@tables)
        }
        render json: hash
      }
    end
  end

  def sitting
    @title  = @nav_title = 'Sitting'
    @tables = current_user.tables_sitting.page(params[:p])
    respond_to do |format|
      format.html
      format.js
      format.json {
        hash = {
          pages: @tables.num_pages,
          tables: tables_to_json(@tables)
        }
        render json: hash
      }
    end
  end

  def sitting_switch
    cookie = cookies[:sitting]
    if !cookie || cookie == '' || cookie == 'ready'
      cookies[:sitting] = 'waiting'
    else
      cookies[:sitting] = 'ready'
    end
    respond_to do |format|
      format.html {
        redirect_to sitting_path
      }
      format.js
    end
  end

end
