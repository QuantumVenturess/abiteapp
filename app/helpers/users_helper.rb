module UsersHelper

  private

    def admin_user
      redirect_to current_user unless current_user.admin?
    end

    def already_signed_in
      deny_access_signed_in unless !signed_in?
    end

    def authenticate
      deny_access unless signed_in?
    end

    def correct_user
      @user = User.find(params[:id])
      if !current_user.admin? && !current_user?(@user)
        redirect_to current_user
      end
    rescue ActiveRecord::RecordNotFound
      redirect_to current_user
    end

end
