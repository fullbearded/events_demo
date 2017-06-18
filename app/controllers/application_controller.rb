# frozen_string_literal: true

class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception

  before_action :require_login, :require_team
  helper_method :current_user, :current_team

  def require_team
    redirect_to launchpad_index_path if session[:team_id].blank?
  end

  def current_team
    @current_team ||= Team.find_by(id: session[:team_id])
  end

  def current_user
    @current_user ||= User.find_by(id: session[:user_id])
  end

  def redirect_to_with_success(msg, redirect_to = :back)
    redirect_to redirect_to, flash: { info: msg }
  end

  def redirect_to_with_failed(msg, redirect_to = :back)
    redirect_to redirect_to, flash: { danger: msg }
  end

  alias halt! redirect_to_with_failed

  # 管理后台未登录跳转
  def not_authenticated
    halt!(I18n.t(:please_login), :login)
  end

  def format_page
    [params[:page] || 1, 100].map(&:to_i).min
  end
end
