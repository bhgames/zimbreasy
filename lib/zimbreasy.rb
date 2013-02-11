require "icalendar"
require "zimbreasy/version"
require "zimbreasy/mail"
require "zimbreasy/account"
module Zimbreasy

  #takes a Time object. outputs string for zimbra api calls.
  def self.zimbra_date(time)
    time.strftime("%Y%m%dT%H%M%S")
  end

  
end
