class PagesController < ApplicationController

  def about
    @title = 'About'
  end

  def test
    u = User.first
    partial = Rails.env.production? ? 'CAABni0jB9PYBA' : 'CAACcASj5klYBA'
    cookies[:remember_token_ios] = "#{u.facebook_id}#{partial}#{u.token}"
    cookies.delete(:remember_token_ios, domain: :all)
  end

end
