module Zimbreasy
  class Calendar
    include Icalendar
  
    attr_accessor :user, :calendar, :auth_user, :auth_password, :format, :url, :params, :domain
  
    def initialize(conf={})
      @user = conf[:user]
      @calendar = conf[:calendar]
      @auth_user = CGI::escape(conf[:auth_user])
      @auth_password = CGI::escape(conf[:auth_password])
      @format = conf[:format]
      @domain = conf[:domain]
      @url = "https://#{@auth_user}:#{@auth_password}@#{@domain}/zimbra/user/#{@user}/#{@calendar}"
      @params = {"auth" => "ba"}
  
      @url += ".#{@format}" unless @format.nil?
      
      @logger = Logger.new("./log/zimbra.log")
      RestClient.log = @logger
    end
  
    def get_events
      JSON.parse(RestClient.get self.url, {:params => self.params})
    end
  
    def free_busy(range=nil)
      self.params.merge!(range) unless range.nil?
      self.params["fmt"] = 'ifb'   
      Icalendar.parse(RestClient.get(self.url, {:params => self.params}))
    end
  
    def create_event(details=nil)
      raise "Must define event details" if details.nil?
      self.params["fmt"] = 'ics' 
      self.format = 'ics' 
        
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
      resposne = RestClient.post self.url, :calendar_event => cfile
  
      cfile.close 
  
      return response
    end
  
  end
end
