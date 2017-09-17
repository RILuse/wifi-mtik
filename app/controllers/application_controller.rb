class ApplicationController < ActionController::Base
  require 'uri'
  protect_from_forgery with: :exception
  before_action :from_router

  def require_admin
    if current_user && !current_user.admin.nil?
    unless current_user.admin?
      puts current_user.admin
      redirect_to root_path
    end

    else
      redirect_to root_path
      end
  end

  def from_router

   if params[:controller] == "wifi"
     if (params.has_key?(:identity) and params.has_key?(:username) and params.has_key?(:error) and params.has_key?(:mac))

       session[:identity] = params[:identity]
       session[:username] = params[:username]
       session[:link_login_only] = params['link-login-only']
       session[:error] = params[:error]
       session[:ip] = params[:ip]
       session[:mac] = URI.decode(params['mac-esc'])

       unless session[:error].blank?
         if session[:error] == "invalid username or password"
           flash[:error] = "Неправильное имя пользователя или пароль"
         else
           flash[:error] = session[:error]
         end

         redirect_to controller: 'wifi', action: 'login', phone: params[:username]
       end
     end
   end
  end
end
