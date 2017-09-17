class HotSpotUser

  attr_accessor :error, :message, :attr, :user_id

  def initialize identity
    @identity = identity
    unless @router = Router.where(:identity => identity).first
      @error = "Не найдена запись роутера"
      raise Exception, @error
    end
  end

  def user_registration order, phone
    @soap = SoapCustomerService.new
    @soap.check_order order
    if @soap.errors
      @error = @soap.errors
      return false
    else
      if ((!@soap.result['message'][0]['status']['isCanceled']) and (@soap.result['message'][0]['phoneNumbers'].include? phone.scan(/[0-9]+/).join))

        code = rand(100000...999999).to_s
        mtik = create_user phone.scan(/[0-9]+/).join, code

        if mtik
          @soap.send_sms phone.scan(/[0-9]+/).join, code
          if @soap.errors
            flash.now[:error] = @soap.errors
            @error = @soap.errors
            return false
          else
            @attr = {:username => phone.scan(/[0-9]+/).join, :password => code}
            @message = "На #{phone} выслан код!"
            return true
          end
        else
          @error = "Техническая проблема #{@error}"
          return false
        end
      else
        @error = "Регистрация по данному заказу не доступна!"
        return false
      end
    end
  end

  def create_user login, code
    #MTik::verbose = true
    user = check_user login
    p user
    if user
      begin
        connection = MTik::command(
            :host => @router.ip,
            :port => @router.port,
            :user => @router.login,
            :pass => @router.password,
            :command => [
                "/ip/hotspot/user/set",
                "=.id=#{user}",
                "=name=#{login}",
                "=password=#{code}",
                "=comment=updated",
            ],
            :limit => 10 ## Auto-cancel after 10 replies
        )
        if connection[0][0].key?('!trap')
          raise Exception, connection
        else
          return true
        end
      rescue Exception => e
        @error = "mtik:#{e}"
        p e
        return false
      end
    else
      begin
        connection = MTik::command(
            :host => @router.ip,
            :port => @router.port,
            :user => @router.login,
            :pass => @router.password,
            :command => [
                "/ip/hotspot/user/add",
                "=name=#{login}",
                "=password=#{code}",
                "=comment=#{login}",
            ],
            :limit => 10 ## Auto-cancel after 10 replies
        )
        if connection[0][0].key?('!trap')
          raise Exception, connection
        else
          return true
        end
      rescue Exception => e
        @error = "mtik:#{e}"
        p e
        return false
      end
    end

  end

  def check_user login
    begin
      connection = MTik::command(
          :host => @router.ip,
          :port => @router.port,
          :user => @router.login,
          :pass => @router.password,
          :command => [
              "/ip/hotspot/user/print",
          ],
          :limit => 10 ## Auto-cancel after 10 replies
      )
      a = connection.to_a
      user = a[0].to_a.find {|x| x['name'] == login}
      if (user.nil?)
        return false
      else
        return user['.id']
      end
    rescue Exception => e
      @error = "mtik:#{e}"
      p e
      return false
    end
  end
end