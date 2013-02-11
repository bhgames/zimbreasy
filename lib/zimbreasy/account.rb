module Zimbreasy
  class Account
    attr_accessor :user, :pass, :endpoint, :client, :soap_namespace, :zimbra_namespace

    def initialize(user, pass, endpoint)
      @user = user
      @pass = pass
      @endpoint = endpoint
      @soap_namespace = {
        "xmlns:soap" => "http://schemas.xmlsoap.org/soap/envelope/"
      }
      @zimbra_namespace = "urn:zimbraAccount"
      auth_request
    end
  
    def auth_request
      make_call("AuthRequest") do |xml|
        xml.AuthRequest({"persistAuthTokenCookie"=> 1, "xmlns" => @zimbra_namespace}) do |xml|
          xml.account(@user, "by" => "name")
          xml.password(@pass)
        end
      end
    end

    def make_call(method,  &block)
      soap_namespace = @soap_namespace 
      #@soap_namespace is undefined inside client.request, is not this obj. So we define it here.

      @client ||= Savon::Client.new do |wsdl|
        wsdl.endpoint = @endpoint
        wsdl.namespace = soap_namespace 
      end

      @client.config.pretty_print_xml = true
      @client.config.log = false

      response = @client.request method  do
        soap.xml do |xml|
          xml.soap(:Envelope, soap_namespace) do |xml|
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
