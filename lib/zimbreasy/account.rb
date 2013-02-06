module Zimbreasy
  class Account
    attr_accessor :user, :pass, :endpoint, :client, :namespace
    def initialize(user, pass, endpoint)
      @user = user
      @pass = pass
      @endpoint = endpoint
      @namespace = {
        "xmlns:soap" => "http://schemas.xmlsoap.org/soap/envelope/"
      }
      auth_request
    end
  
    def auth_request
      make_call("AuthRequest", @namespace) do |xml|
        xml.AuthRequest({"persistAuthTokenCookie"=> 1, "xmlns" => "urn:zimbraAccount"}) do |xml|
          xml.account(@user, "by" => "name")
          xml.password(@pass)
        end
      end
    end

    def make_call(method,  namespace, &block)

      @client ||= Savon::Client.new do |wsdl|
        wsdl.endpoint = @endpoint
        wsdl.namespace = namespace 
      end
        
      @client.config.pretty_print_xml = true
      @client.config.log = true

      response = @client.request method  do
        soap.xml do |xml|
          xml.soap(:Envelope, namespace) do |xml|
            xml.soap(:Header) 
            xml.soap(:Body) do |xml|
              yield xml
            end
          end
        end
      end
    end
  end
end
