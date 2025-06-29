class ApplicationController < ActionController::Base
  # Only allow modern browsers supporting webp images, web push, badges, import maps, CSS nesting, and CSS :has.
  allow_browser versions: :modern
  
  # VULNERABLE: Open Redirect - 意図的な脆弱性（実験目的）
  def after_sign_in_path_for(resource)
    if params[:redirect_url].present?
      # 検証なしでリダイレクト先を使用
      params[:redirect_url]
    else
      root_path
    end
  end
  
  def after_sign_out_path_for(resource_or_scope)
    if params[:redirect_url].present?
      # VULNERABLE: Open Redirect - 意図的な脆弱性（実験目的）
      params[:redirect_url]
    else
      root_path
    end
  end
end
