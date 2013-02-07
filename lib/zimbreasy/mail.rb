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
      account.make_call("CreateAppointmentRequest") do |xml|
        xml.CreateAppointmentRequest({ "xmlns" => @zimbra_namespace}) do |xml|
          xml.m({"su" => params[:subject]}) do |xml|
            xml.mp({"ct" =>(params[:mime_type] || "text/plain")})
            xml.inv({"rsvp" => "1", "compNum" => "0", "method" => "none", "name" => params[:name] }) do |xml| 
              xml.mp({"ct" =>(params[:mime_type] || "text/plain")})
              xml.desc(params[:desc]) 
              xml.s({"d" => Zimbreasy.zimbra_date(params[:start_time])}) if params[:start_time]
              xml.e({"d" => Zimbreasy.zimbra_date(params[:end_time])}) if params[:end_time]
            end 
            
            xml.e({"a" => params[:appointee_email], "t" => "t"})
          end
        end
      end

    calendar = Calendar.new   
    calendar.event do
      dtstart       details[:dtstart]
      dtend         details[:dtend]
      summary     details[:summary]
      description details[:description]
      klass       details[:klass] || "PRIVATE"  
    end
    
    `mkdir -p ./tmp/calendars`
    file_name = "./tmp/calendars/cal_#{calendar.object_id}_#{Time.now.to_f}.ics"
    cfile = File.new(file_name, 'w+')
    cfile.write(calendar.to_ical)

    end
 
    def get_appointment
      account.make_call("CreateAppointmentRequest") do |xml|
        xml.CreateAppointmentRequest({ "xmlns" => @zimbra_namespace}) do |xml|
          xml.m({"su" => params[:subject]}) do |xml|
            xml.mp({"ct" =>(params[:mime_type] || "text/plain")})
            xml.inv({"rsvp" => "1", "compNum" => "0", "method" => "none", "name" => params[:name] }) do |xml| 
              xml.mp({"ct" =>(params[:mime_type] || "text/plain")})
              xml.desc(params[:desc]) 
              xml.s({"d" => Zimbreasy.zimbra_date(params[:start_time])}) if params[:start_time]
              xml.e({"d" => Zimbreasy.zimbra_date(params[:end_time])}) if params[:end_time]
            end 
            
            xml.e({"a" => params[:appointee_email], "t" => "t"})
          end
        end
      end

    end 

  end
end
