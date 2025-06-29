class UsersController < ApplicationController
  before_action :authenticate_user!
  
  def profile
    @user = current_user
  end

  def update
    @user = current_user
    # VULNERABLE: Mass Assignment - 意図的な脆弱性（実験目的）
    # permit! を使用して全てのパラメータを許可
    if @user.update(params.require(:user).permit!)
      redirect_to users_profile_path, notice: "Profile updated successfully."
    else
      render :profile
    end
  end
end
