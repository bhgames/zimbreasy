module Zimbreasy
  class Mail
    include Icalendar
    attr_accessor :account, :zimbra_namespace
    def initialize(account)
      @account = account
      @zimbra_namespace = "urn:zimbraMail"
    end

    #Params can contain the following:
    #:appointee_email(req)
    #:start_time(opt)
    #:end_time(opt)
    #:name(opt)
    #:subject(opt)
    #:desc(opt)
    #:mime_type(opt)
    def create_appointment(params)
      params[:start_time] = Zimbreasy.zimbra_date(params[:start_time]) if params[:start_time]
      params[:end_time] = Zimbreasy.zimbra_date(params[:end_time]) if params[:end_time]

      response = account.make_call("CreateAppointmentRequest") do |xml|
        xml.CreateAppointmentRequest({ "xmlns" => @zimbra_namespace}) do |xml|
          xml.m({"su" => params[:subject]}) do |xml|
            xml.mp({"ct" =>(params[:mime_type] || "text/plain")})
            xml.inv({"rsvp" => "1", "compNum" => "0", "method" => "none", "name" => params[:name] }) do |xml| 
              xml.mp({"ct" =>(params[:mime_type] || "text/plain")})
              xml.desc(params[:desc]) 
              xml.s({"d" => params[:start_time]}) if params[:start_time]
              xml.e({"d" => params[:end_time]}) if params[:end_time]
            end 
            
            xml.e({"a" => params[:appointee_email], "t" => "t"})
          end
        end
      end
      params.merge!({:appt_id => response.body[:create_appointment_response][:@appt_id]})
      make_ical(params)
    end
 
    def make_ical(params)
      calendar = Calendar.new   
      calendar.event do
        dtstart       params[:start_time]
        dtend         params[:end_time]
        summary       params[:desc]
        description   params[:desc]
        uid           params[:appt_id]
        klass         "PRIVATE"  
      end
      
      calendar.to_ical
    end

    def get_appointment(id)
      response = account.make_call("GetAppointmentRequest") do |xml|
        xml.GetAppointmentRequest({ "xmlns" => @zimbra_namespace, "id" => id})
      end

      comp = response[:get_appointment_response][:appt][:inv][:comp]
      hash = {:start_time => comp[:s][:@d], :end_time => comp[:e][:@d], :desc => comp[:desc], :appt_id => id}
      make_ical(hash)
    end 

  end
end
