# 登陆注册验证
class SessionController < ApplicationController
  skip_before_action :require_login, :require_team, except: [:destroy]
  layout false

  def new; end

  def create
    if login(params[:username], params[:password], params[:remember].present?)
      redirect_to_with_success('登录成功！', :root)
    else
      halt!('用户名或密码错误！')
    end
  end

  def destroy
    logout
    redirect_to_with_success('安全退出！', :login)
  end
end
