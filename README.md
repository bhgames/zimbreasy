# Zimbreasy

2007!

Crankin will get that joke, he is to be thanked for assistance on this. 

This is an open sourced wrapper for the Zimbra API. I only added functionality for CRUD on Calender Appointments,
because that's all I needed for the job I'm getting done. However, the code already contained within the libraries for calendars
and the structure make this an easily extensible gem if you need it for other purposes.

The API documentation I am using is located at

http://files.zimbra.com/docs/soap_api/8.0/soapapi-zimbra-doc/api-reference/index.html

Everybody who's interested in finally wrapping Zimbra well for Ruby, please download the gem and submit pull requests 
with more of the methods on this API built out(there are over 100.)

This gem is still in it's infancy and has little to no error handling! I appreciate all the help I can get on this project, Zimbra is big!

## Installation

Add this line to your application's Gemfile:

    gem 'zimbreasy'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install zimbreasy

## Usage

It's pretty simple to use, I will post some examples:

    zs = Zimbreasy::Account.new('username', 'password', "https://yourzimbraserver.com/service/soap"); #login
    zm = Zimbreasy::Mail.new(zs); #create a Zimbreasy::Mail object. This has methods for the ZimbraMail submodule of their API.
    z = zm.create_appointment({
      :appointee_email => "neo@matrix.com", 
      :start_time => Time.now+1.days, 
      :end_time => (Time.now+1.days+1.hours), 
      :name => "Joss Whedon Meeting", 
      :subject => "Hallelujah", 
      :desc => "Ridiculous stuff happening here"
    }) #I create an appointment.

    => "BEGIN:VCALENDAR\r\nCALSCALE:GREGORIAN\r\nPRODID:iCalendar-Ruby\r\nVERSION:2.0\r\nBEGIN:VEVENT\r\nDESCRIPTION:Poopmaster\r\nDTEND:20130208T171612\r\nDTSTAMP:20130207T161614\r\nDTSTART:20130208T161612\r\nCLASS:PRIVATE\r\nSEQUENCE:0\r\nSUMMARY:Jossss\r\nUID:336-335\r\nEND:VEVENT\r\nEND:VCALENDAR\r\n"


create_appointment returns ics formatted data, for use with icalendar. Notice that the UID in the data is 336-335. This is an invitation id, not an appointment id.
The appointment id is 336, the first part of it.

The other methods of note:

    zm.get_appointment(336) #takes appt id
  
    zm.modify_appointment({
      :appointee_email => "neo@matrix.com", 
      :start_time => Time.now, 
      :end_time => (Time.now+2.hours), 
      :name => "Joss Whedon!!!", 
      :subject => "Hallelujah 2: The Electric Boogaloo", 
      :desc => "Yoda Fights Back", :inv_id => "336-335"
    })

    zm.cancel_appointment("336-335")

You'll notice get_appointment uses an actual appointment id, whereas modify appt and cancel appt need inv ids. I don't know why this is, 
it seems Zimbra API only works with invitation, not appointment ids, when it comes to these methods. Get just needs appt ids. The final method of note is

    zm.get_appt_summaries(Time.now-1.days, Time.now)

This just returns appointment Ics texts in an array. First arg is a Time object representing start date, second arg is end date.

## Contributing

It'd be great if someone could write tests for these methods, I haven't had the time. If you want to write tests,
please do!

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Added some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
