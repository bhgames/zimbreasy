module Zimbreasy
  module Account
  
    def self.auth(auth)
      client = Savon::Client.new do |xml|
        wsdl.endpoint = "/service/soap"
        wsdl.namespace
      end
        
      client.config.pretty_print_xml = true
      client.config.log = false

      namespaces = {
        "xmlns:soap" => "http://schemas.xmlsoap.org/soap/envelope/", #used to be soapenv not soap
        "xmlns:xsi"=>"http://www.w3.org/2001/XMLSchema-instance",
        "xmlns:xsd"=>"http://www.w3.org/2001/XMLSchema"
      }
      mini_namespaces = {
        "xmlns="=>"urn:zimbraAccount"
      }
      response = client.request "AuthRequest"  do
        http.headers = { "Content-Length" => "0", "Connection" => "Keep-Alive" }
        client.http.headers["SOAPAction"] =  "http://schema.microbilt.com/messages/GetReport"

        soap.xml do |xml|
          xml.soap(:Envelope, namespaces) do |xml|
            xml.soap(:Header) 
            xml.soap(:Body) do |xml|
              xml.AuthRequest({"persistAuthTokenCookie"=> 1}) do |xml|
                xml.account(auth[:user], {"by" => "name"})
                xml.password(auth[:password])
              end
            end
          end
        end
      end
    end
  end
end
