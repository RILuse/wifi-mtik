class SoapCustomerService
  require 'json'
  attr_accessor :errors, :status, :result

  def initialize
    @client = Savon::Client.new(
        wsdl: SOAP['url'],
        basic_auth: [SOAP['username'], SOAP['password']],
        log: false,
        ssl_verify_mode: :none,
        env_namespace: :soap,
        namespace_identifier: :voz,
        convert_request_keys_to: :none,
        open_timeout: 10,
        read_timeout: 10
    )
  end

  def get_operations
    @client.operations
  end

  def errors?
    if :errors.empty?
      return true
    end
    return false
  end

  def send_sms phone, text
    @errors = nil
    data = {
        "tel" => phone,
        "text" => "#{text} - Код входа в зону Wifi Vozovoz.ru",
        "context" => {
            "wifi-service" => "true",
            "browser" => "Ruby on Rails"
        }
    }
    begin

      @response = @client.call(:ws_request, message: {
          :RequestType => "sendsms",
          :InData => data.to_json,
          :userIP => '13.33.31.3'

      })
      response = JSON.parse(@response.body[:ws_request_response][:return])
      if response['response'] == "error"
        raise Exception, response['message']['message']
      else
        return true
      end

    rescue Exception => e
      @errors = e
      if Rails.env.development?
        puts "Exception: #{@errors}".red
      end

    end
    return false
  end

  def check_order order
    @errors = nil
    data = {
        "number" => order,
        "context" => {
            "wifi-service" => "true",
            "browser" => "Ruby on Rails"
        }
    }

    begin

      @response = @client.call(:ws_request, message: {
          :RequestType => "getOrderMini",
          :InData => data.to_json,
          :userIP => '13.33.31.3'

      })
      response = JSON.parse(@response.body[:ws_request_response][:return])
      if response['response'] == "error"
        raise Exception, response['message']['message']
      else
        @result = response
        return true
      end

    rescue Exception => e
      @errors = e
      if Rails.env.development?
        puts "Exception: #{@errors}".red
      end
      return false
    end
    return false
  end
end