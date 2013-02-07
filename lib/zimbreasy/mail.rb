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
          appointment_xml_block(xml, params)
        end
      end
      params.merge!({:appt_id => response.body[:create_appointment_response][:@cal_item_id]})
      make_ical(params)
    end
 
    def make_ical(params)
      calendar = Calendar.new   
      calendar.event do
        dtstart       params[:start_time]
        dtend         params[:end_time]
        summary       params[:name]
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

      hash = {
        :start_time => comp[:s][:@d], 
        :end_time => comp[:e][:@d], 
        :desc => comp[:desc],  
        :name => comp[:@name],
        :appt_id => id
      }

      make_ical(hash)
    end 

    def get_appt_summaries(start_date, end_date)
      start_date = start_date.to_i*1000 #it wants millis, to_i gives seconds.
      end_date = end_date.to_i*1000

      response = account.make_call("GetApptSummariesRequest") do |xml|
        xml.GetApptSummariesRequest({ "xmlns" => @zimbra_namespace, "e" => end_date, "s" => start_date})
      end

      return [] if response[:get_appt_summaries_response][:appt].nil?

      appts = []

      response[:get_appt_summaries_response][:appt].each do |appt|

        inst = appt[:inst]
                  
        hash = {
          :start_time => Zimbreasy.zimbra_date(Time.at(inst[:@s].to_f/1000.0)), 
          :name => appt[:@name], 
          :appt_id => appt[:@id]
        }

        appts << make_ical(hash)
      end
      
      appts
    end 

    #same param options as create_appointment, but you can add :appt_id too.
    def modify_appointment(params)
      params[:start_time] = Zimbreasy.zimbra_date(params[:start_time]) if params[:start_time]
      params[:end_time] = Zimbreasy.zimbra_date(params[:end_time]) if params[:end_time]

      response = account.make_call("ModifyAppointmentRequest") do |xml|
        xml.ModifyAppointmentRequest({ 
          "xmlns" => @zimbra_namespace, 
          "id" => "#{params[:appt_id]}-#{params[:appt_id].to_i-1}"
        }) do |xml|
          appointment_xml_block(xml, params)
        end
      end
    
      make_ical(params)
    end

    private

    def appointment_xml_block(xml, params)
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
end
