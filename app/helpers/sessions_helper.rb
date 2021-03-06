module SessionsHelper

  def current_user
    @current_user ||= user_from_remember_token
  end

  def current_user=(user)
    @current_user = user
  end

  def current_user?(user)
    user == current_user
  end

  def deny_access
    store_location
    redirect_to sign_in_path
  end

  def deny_access_signed_in
    redirect_to root_path
  end

  def redirect_back_or(default)
    redirect_to(session[:return_to] || default)
    clear_return_to
  end

  def sign_in(user)
    cookies.permanent.signed[:remember_token_abiteapp] = { value: [user.id, 
      user.token], domain: :all }
    user.in_count += 1
    user.last_in = Time.now
    user.save
    self.current_user = user
  end

  def sign_out
    cookies.delete(:remember_token_abiteapp, domain: :all)
    self.current_user = nil
  end

  def signed_in?
    if !current_user.nil?
      true
    end
  end

  private

    def clear_return_to
      session[:return_to] = nil
    end

    def remember_token
      abiteapp = cookies.signed[:remember_token_abiteapp]
      bite_access_token = params[:bite_access_token]
      if abiteapp && !abiteapp.empty?
        abiteapp
      elsif bite_access_token && !bite_access_token.empty?
        [0, bite_access_token]
      else
        [nil, nil]
      end
    end

    def store_location
      session[:return_to] = request.fullpath
    end

    def user_from_remember_token
      User.authenticate_with_token(*remember_token)
    end
end
