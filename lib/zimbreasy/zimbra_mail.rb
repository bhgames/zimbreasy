module Zimbreasy
  class Mail
    client = Savon::Client.new
      
    client.config.pretty_print_xml = true
    client.config.log = false


    response = client.request "CreateAppointmentRequest"  do
      soap.xml do |xml|
<CreateAppointmentRequest [echo="{echo} (0|1)"] [max="{max-inlined-length} (Integer)"] [html="{want-html} (0|1)"]
                                 [neuter="{neuter} (0|1)"] [forcesend="{force-send} (0|1)"]> ## CreateAppointmentRequest
        <m [aid="{uploaded-MIME-body-ID}"] [origid="{orig-id}"] [rt="{reply-type-r|w}"] [idnt="{identity-id}"]
               [su="{subject}"] [irt="{in-reply-to-message-id-hdr}"] [l="{folder-id}"] [f="{flags}"]> ## Msg
            (<header [name="..."]>{value}</header> ## Msg$Header)*
            <content>{content} (String)</content>
            <mp [ct="{content-type}"] [content="{content}"] [ci="{content-id}"]> ## MimePartInfo
                (<mp> ... </mp> ## See /m/mp [ ## MimePartInfo] # [inside itself])*
                <attach [aid="{attach-upload-id}"]> ## AttachmentsInfo
                    List of any of: {
                        <mp mid="{message-id}" part="{part}" [optional="{optional} (0|1)"] /> ## MimePartAttachSpec
                        <m id="{id}" [optional="{optional} (0|1)"] /> ## MsgAttachSpec
                        <cn id="{id}" [optional="{optional} (0|1)"] /> ## ContactAttachSpec
                        <doc [path="{document-path}"] [id="{item-id}"] [ver="{version} (Integer)"]
                                 [optional="{optional} (0|1)"] /> ## DocAttachSpec
                    }
                 </attach>
             </mp>
            <attach [aid="{attach-upload-id}"]> ... </attach> ## See /m/mp/attach [ ## AttachmentsInfo]
            <inv [id="{id}"] [ct="{content-type}"] [ci="{content-id}"] method="{invite-comp-method}"
                     compNum="{invite-comp-num} (int)" rsvp="{rsvp} (0|1)" [priority="{invite-comp-priority-0-9}"]
                     [name="{invite-comp-name}"] [loc="{invite-comp-location}"] [percentComplete="{task-percent-complete}"]
                     [completed="{task-completed-yyyyMMddThhmmssZ}"] [noBlob="{no-blob-data} (0|1)"]
                     [fba="{freebusy-actual}"] [fb="{freebusy-status}"] [transp="{transparency}"]
                     [isOrg="{is-organizer} (0|1)"] [x_uid="{x-uid}"] [uid="{uid-for-create}"]
                     [seq="{sequence-num} (Integer)"] [d="{invite-comp-date} (Long)"]
                     [calItemId="{mail-item-id-of-appointment}"] [apptId="{deprecated-appt-id}"]
                     [ciFolder="{cal-item-folder}"] [status="{invite-comp-status}"] [class="{invite-comp-class}"]
                     [url="{invite-comp-url}"] [ex="{is-exception} (0|1)"] [ridZ="{utc-recurrence-id}"]
                     [allDay="{is-all-day} (0|1)"] [draft="{is-draft} (0|1)"] [neverSent="{attendees-never-notified} (0|1)"]
                     [changes="{comma-sep-changed-data}"]> ## InvitationInfo
                <content [uid="{UID}"] [summary="{summary}"]>{content}</content> ## RawInvite
                <comp method="{invite-comp-method}" compNum="{invite-comp-num} (int)" rsvp="{rsvp} (0|1)"
                          [priority="{invite-comp-priority-0-9}"] [name="{invite-comp-name}"] [loc="{invite-comp-location}"]
                          [percentComplete="{task-percent-complete}"] [completed="{task-completed-yyyyMMddThhmmssZ}"]
                          [noBlob="{no-blob-data} (0|1)"] [fba="{freebusy-actual}"] [fb="{freebusy-status}"]
                          [transp="{transparency}"] [isOrg="{is-organizer} (0|1)"] [x_uid="{x-uid}"] [uid="{uid-for-create}"]
                          [seq="{sequence-num} (Integer)"] [d="{invite-comp-date} (Long)"]
                          [calItemId="{mail-item-id-of-appointment}"] [apptId="{deprecated-appt-id}"]
                          [ciFolder="{cal-item-folder}"] [status="{invite-comp-status}"] [class="{invite-comp-class}"]
                          [url="{invite-comp-url}"] [ex="{is-exception} (0|1)"] [ridZ="{utc-recurrence-id}"]
                          [allDay="{is-all-day} (0|1)"] [draft="{is-draft} (0|1)"]
                          [neverSent="{attendees-never-notified} (0|1)"] [changes="{comma-sep-changed-data}"]> ## InviteComponent
                    (<category>{categories} (String)</category>)*
                    (<comment>{comments} (String)</comment>)*
                    (<contact>{contacts} (String)</contact>)*
                    <geo [lat="{longitude}"] [lon="{longitude}"] /> ## GeoInfo
                    (<at [a="{email-address}"] [url="{url}"] [d="{friendly-name}"] [sentBy="{sent-by}"] [dir="{dir}"]
                             [lang="{language}"] [cutype="{calendar-user-type}"] [role="{role}"]
                             [ptst="{participation-status}"] [rsvp="{rsvp} (0|1)"] [member="{member}"]
                             [delTo="{delegated-to}"] [delFrom="{delegated-from}"]> ## CalendarAttendee
                        (<xparam name="{xparam-name}" value="{xparam-value}" /> ## XParam)*
                      </at>)*
                    (<alarm action="{alarm-action}"> ## AlarmInfo
                        <trigger> ## AlarmTriggerInfo
                            <abs d="{YYYYMMDDThhmmssZ}" /> ## DateAttr
                            <rel [neg="{duration-negative} (0|1)"] [w="{duration-weeks} (Integer)"]
                                     [d="{duration-days} (Integer)"] [h="{duration-hours} (Integer)"]
                                     [m="{duration-minutes} (Integer)"] [s="{duration-seconds} (Integer)"]
                                     [related="{alarm-related}"] [count="{alarm-repeat-count} (Integer)"] /> ## DurationInfo
                         </trigger>
                        <repeat ... /> ## See /m/inv/comp/alarm/trigger/rel [ ## DurationInfo]
                        <desc>{description} (String)</desc>
                        <attach [uri="{alarm-attach-uri}"] [ct="{alarm-attach-content-type}"]>{binaryB64Data}</attach> ## CalendarAttach
                        <summary>{summary} (String)</summary>
                        (<at ... > ... </at> ## See /m/inv/comp/at [ ## CalendarAttendee])*
                        (<xprop name="{xprop-name}" value="{xprop-value}"> ## XProp
                            (<xparam name="{xparam-name}" value="{xparam-value}" /> ## See /m/inv/comp/at/xparam [ ## XParam])*
                          </xprop>)*
                      </alarm>)*
                    (<xprop name="{xprop-name}" value="{xprop-value}"> ... </xprop> ## See /m/inv/comp/alarm/xprop [ ## XProp])*
                    <fr>{fragment} (String)</fr>
                    <desc>{description} (String)</desc>
                    <descHtml>{htmlDescription} (String)</descHtml>
                    <or [a="{email-address}"] [url="{url}"] [d="{friendly-name}"] [sentBy="{sent-by}"] [dir="{dir}"]
                            [lang="{language}"]> ## CalOrganizer
                        (<xparam name="{xparam-name}" value="{xparam-value}" /> ## See /m/inv/comp/at/xparam [ ## XParam])*
                     </or>
                    <recur> ## RecurrenceInfo
                        List of any of: {
                            <add> ## AddRecurrenceInfo
                                List of any of: {
                                    <add> ... </add> ## See /m/inv/comp/recur/add [ ## AddRecurrenceInfo] # [inside itself]
                                    <exclude> ## ExcludeRecurrenceInfo
                                        List of any of: {
                                            <add> ... </add> ## See /m/inv/comp/recur/add [ ## AddRecurrenceInfo] # [inside itself]
                                            <exclude> ... </exclude> ## See /m/inv/comp/recur/add/exclude [ ## ExcludeRecurrenceInfo] # [inside itself]
                                            <except rangeType="{range-type} (int)" recurId="{YYMMDD[THHMMSS[Z]]}"
                                                        [tz="{timezone-name}"] [ridZ="{YYMMDDTHHMMSSZ}"]> ## ExceptionRuleInfo
                                                <add> ... </add> ## See /m/inv/comp/recur [ ## RecurrenceInfo] # [inside itself]
                                                <exclude> ... </exclude> ## See /m/inv/comp/recur [ ## RecurrenceInfo] # [inside itself]
                                             </except>
                                            <cancel rangeType="{range-type} (int)" recurId="{YYMMDD[THHMMSS[Z]]}"
                                                        [tz="{timezone-name}"] [ridZ="{YYMMDDTHHMMSSZ}"] /> ## CancelRuleInfo
                                            <dates [tz="{TZID}"]> ## SingleDates
                                                (<dtval> ## DtVal
                                                    <s [d="{YYYYMMDD['T'HHMMSS[Z]]}"] [tz="{timezone-identifier}"]
                                                           [u="{utc-time} (Long)"] /> ## DtTimeInfo
                                                    <e ... /> ## See /m/inv/comp/recur/add/exclude/dates/dtval/s [ ## DtTimeInfo]
                                                    <dur ... /> ## See /m/inv/comp/alarm/trigger/rel [ ## DurationInfo]
                                                  </dtval>)*
                                             </dates>
                                            <rule freq="{freq}"> ## SimpleRepeatingRule
                                                <until d="{YYYYMMDD[ThhmmssZ]}" /> ## DateTimeStringAttr
                                                <count num="{num} (int)" /> ## NumAttr
                                                <interval ival="{rule-interval} (int)" /> ## IntervalRule
                                                <bysecond seclist="{second-list}" /> ## BySecondRule
                                                <byminute minlist="{minute-list}" /> ## ByMinuteRule
                                                <byhour hrlist="{hour-list}" /> ## ByHourRule
                                                <byday> ## ByDayRule
                                                    (<wkday day="{weekday}" [ordwk="{ord-wk-[[+]|-]num} (Integer)"] /> ## WkDay)*
                                                 </byday>
                                                <bymonthday modaylist="{modaylist}" /> ## ByMonthDayRule
                                                <byyearday yrdaylist="{byyearday-yrdaylist}" /> ## ByYearDayRule
                                                <byweekno wklist="{byweekno-wklist}" /> ## ByWeekNoRule
                                                <bymonth molist="{month-list}" /> ## ByMonthRule
                                                <bysetpos poslist="{bysetpos-list}" /> ## BySetPosRule
                                                <wkst day="{weekday}" /> ## WkstRule
                                                (<rule-x-name [name="{xname-name}"] [value="{xname-value}"] /> ## XNameRule)*
                                             </rule>
                                        }
                                     </exclude>
                                    <except ... > ... </except> ## See /m/inv/comp/recur/add/exclude/except [ ## ExceptionRuleInfo]
                                    <cancel ... /> ## See /m/inv/comp/recur/add/exclude/cancel [ ## CancelRuleInfo]
                                    <dates [tz="{TZID}"]> ... </dates> ## See /m/inv/comp/recur/add/exclude/dates [ ## SingleDates]
                                    <rule freq="{freq}"> ... </rule> ## See /m/inv/comp/recur/add/exclude/rule [ ## SimpleRepeatingRule]
                                }
                             </add>
                            <exclude> ... </exclude> ## See /m/inv/comp/recur/add/exclude [ ## ExcludeRecurrenceInfo]
                            <except ... > ... </except> ## See /m/inv/comp/recur/add/exclude/except [ ## ExceptionRuleInfo]
                            <cancel ... /> ## See /m/inv/comp/recur/add/exclude/cancel [ ## CancelRuleInfo]
                            <dates [tz="{TZID}"]> ... </dates> ## See /m/inv/comp/recur/add/exclude/dates [ ## SingleDates]
                            <rule freq="{freq}"> ... </rule> ## See /m/inv/comp/recur/add/exclude/rule [ ## SimpleRepeatingRule]
                        }
                     </recur>
                    <exceptId d="{DATETIME-YYYYMMDD['T'HHMMSS[Z]]}" [tz="{timezone-identifier}"]
                                  [rangeType="{range-type} (Integer)"] /> ## ExceptionRecurIdInfo
                    <s ... /> ## See /m/inv/comp/recur/add/exclude/dates/dtval/s [ ## DtTimeInfo]
                    <e ... /> ## See /m/inv/comp/recur/add/exclude/dates/dtval/s [ ## DtTimeInfo]
                    <dur ... /> ## See /m/inv/comp/alarm/trigger/rel [ ## DurationInfo]
                 </comp>
                (<tz id="{timezone-id}" stdoff="{timezone-std-offset} (Integer)"
                         dayoff="{timezone-daylight-offset} (Integer)" [stdname="..."] [dayname="..."]> ## CalTZInfo
                    <standard [week="{tzonset-week} (Integer)"] [wkday="{tzonset-day-of-week} (Integer)"]
                                  mon="{tzonset-month} (Integer)" [mday="{tzonset-day-of-month} (Integer)"]
                                  hour="{tzonset-hour} (Integer)" min="{tzonset-minute} (Integer)"
                                  sec="{tzonset-second} (Integer)" /> ## TzOnsetInfo
                    <daylight ... /> ## See /m/inv/tz/standard [ ## TzOnsetInfo]
                  </tz>)*
                (<mp ... > ... </mp> ## See /m/mp [ ## MimePartInfo])*
                <attach [aid="{attach-upload-id}"]> ... </attach> ## See /m/mp/attach [ ## AttachmentsInfo]
                (<category>{categories} (String)</category>)*
                (<comment>{comments} (String)</comment>)*
                (<contact>{contacts} (String)</contact>)*
                <geo [lat="{longitude}"] [lon="{longitude}"] /> ## See /m/inv/comp/geo [ ## GeoInfo]
                (<at ... > ... </at> ## See /m/inv/comp/at [ ## CalendarAttendee])*
                (<alarm action="{alarm-action}"> ... </alarm> ## See /m/inv/comp/alarm [ ## AlarmInfo])*
                (<xprop name="{xprop-name}" value="{xprop-value}"> ... </xprop> ## See /m/inv/comp/alarm/xprop [ ## XProp])*
                <fr>{fragment} (String)</fr>
                <desc>{description} (String)</desc>
                <descHtml>{htmlDescription} (String)</descHtml>
                <or ... > ... </or> ## See /m/inv/comp/or [ ## CalOrganizer]
                <recur> ... </recur> ## See /m/inv/comp/recur [ ## RecurrenceInfo]
                <exceptId ... /> ## See /m/inv/comp/exceptId [ ## ExceptionRecurIdInfo]
                <s ... /> ## See /m/inv/comp/recur/add/exclude/dates/dtval/s [ ## DtTimeInfo]
                <e ... /> ## See /m/inv/comp/recur/add/exclude/dates/dtval/s [ ## DtTimeInfo]
                <dur ... /> ## See /m/inv/comp/alarm/trigger/rel [ ## DurationInfo]
             </inv>
            (<e a="{email-addr}" [t="{address-type}"] [p="{personal-name}"] /> ## EmailAddrInfo)*
            (<tz ... > ... </tz> ## See /m/inv/tz [ ## CalTZInfo])*
            <fr>{fragment} (String)</fr>
         </m>
    </CreateAppointmentRequest>
      end
    end
  end
end
