class SeatsController < ApplicationController
  before_filter :authenticate

  def explore
    @title  = @nav_title = 'Explore'
    @tables = current_user.tables_not_sitting.page(params[:p])
    respond_to do |format|
      format.html
      format.js
      format.json {
        if params[:table_ids] && !params[:table_ids].empty?
          table_ids = params[:table_ids].split(',').map { |id| id.to_i }
          tables_to_remove = table_ids - @tables.map { |table| table.id }
        else
          tables_to_remove = []
        end
        hash = {
          pages: @tables.num_pages,
          tables: tables_to_json(@tables),
          tables_to_remove: tables_to_remove
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
        if params[:table_ids] && !params[:table_ids].empty?
          table_ids = params[:table_ids].split(',').map { |id| id.to_i }
          tables_to_remove = table_ids - @tables.map { |table| table.id }
        else
          tables_to_remove = []
        end
        hash = {
          pages: @tables.num_pages,
          tables: tables_to_json(@tables),
          tables_to_remove: tables_to_remove
        }
        render json: hash
      }
    end
  end

  def sitting_all
    respond_to do |format|
      format.html {
        redirect_to sitting_path
      }
      format.json {
        render json: current_user.tables_sitting.map { |table| table.id }
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
