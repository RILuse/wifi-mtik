class WifiController < ApplicationController
  before_action :permit_params

  def index
  end

  def login
    @wifi = WifiLoginForm.new
    if params.has_key?(:phone)
      @wifi.phone = params[:phone]
    end
  end

  def login_post
    puts "POST"

    @wifi = WifiLoginForm.new params[:wifi_login_form]
    @wifi.login = true
    if @wifi.valid?
      begin

        @u = HotspotCustomer.where(:login => params[:wifi_login_form][:phone].scan(/[0-9]+/).join).first
        #p @u.code_status
        if @u.try(:code_status) == true
          if ((@u.login === params[:wifi_login_form][:phone].scan(/[0-9]+/).join) and (@u.password.to_s === params[:wifi_login_form][:code]))
            @u.update_attributes(:code_status =>false)
            redirect_to "#{session[:link_login_only]}?username=#{@u.login}&password=#{params[:wifi_login_form][:code]}&dst=https://google.com"
            begin
              @u = HotspotLog.new
              @u.login = params[:wifi_login_form][:phone].scan(/[0-9]+/).join
              @u.password = params[:wifi_login_form][:code]
              @u.router_id = session[:identity]
              @u.ip = session[:ip]
              @u.mac = session[:mac]
              @u.save!
            rescue Exception => e
              p e
            end
            puts "Login!"
          else
            flash.now[:error] = "Логин или пароль введены не верно!"
            render action: "login"
          end
        else
          flash[:error] = "Ваш код использован! Пройдите повторную регистрацию для получения нового кода"
          redirect_to wifi_registration_path :phone => params[:wifi_login_form][:phone]

        end
      rescue Exception => e
        flash.now[:error] = e
        render action: "login"
      end
    else
      puts params[:phone]
      render action: "login"
    end
  end

  def logout

    @soap = SoapCustomerService.new
    @soap.send_sms '79646103073', 'hello i am ruby motherfucker'
    if @soap.errors
      flash[:error] = @soap.errors
      render action: "logout"
    else
      flash[:success] = "Сообщение отправлено!"
      redirect_to ('/')
    end
  end

  def check

  end


  def registration
    @wifi = WifiLoginForm.new
  end

  def registration_post
    puts "POST"
    @wifi = WifiLoginForm.new params[:wifi_login_form]
    @wifi.registration = true
    if @wifi.valid?
      begin
        hot_spot = HotSpotUser.new session[:identity]
        if hot_spot.user_registration params[:wifi_login_form][:order], params[:wifi_login_form][:phone]
          if HotspotCustomer.where(:login => params[:wifi_login_form][:phone].scan(/[0-9]+/).join).blank?
            @u = HotspotCustomer.new
            @u.login = hot_spot.attr[:username]
            @u.password = hot_spot.attr[:password]
            @u.router_id = session[:identity]
            @u.ip = session[:ip]
            @u.mac = session[:mac]
            @u.code_status = true
            @u.save!
          else
            @u = HotspotCustomer.where(:login => hot_spot.attr[:username]).first
            @u.update_attributes(:password => hot_spot.attr[:password], :router_id => session[:identity], :ip => session[:ip], :code_status => true, :mac => session[:mac])
          end
          flash[:success] = hot_spot.message
          redirect_to wifi_login_path :phone => params[:wifi_login_form][:phone]
        else
          flash.now[:error] = hot_spot.error
          return render action: "registration"
        end
      rescue Exception => e
        flash.now[:error] = "Исключение #{e}"
        return render action: "registration"
      end
    else
      return render action: "registration"
    end
  end


  def agreement
  end

  def permit_params
    params.permit!
  end

end
