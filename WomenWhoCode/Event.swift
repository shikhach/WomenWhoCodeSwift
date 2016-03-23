//
//  Event.swift
//  WomenWhoCode
//
//  Created by Prasanthi Relangi on 3/5/16.
//  Copyright © 2016 WomenWhoCode. All rights reserved.
//

import UIKit
import Parse
import SwiftDate

class Event: NSObject {
    
    //Parse objectId
    var objectId: String?
    
    var name: String?
    var location: String?
    var eventDate : NSDate?  //will contain the complete event time details (month,date and time)
    var eventDateString: String?
    var createdAt: NSDate?
    var eventDescription: String? //description is already present in the super class and gives an error
    var type: String?  //Can be Mobile, Web, Social ; Will be used to load the correct image in the Event listing
    var attendeeLimit: Int?
    var rsvpCount: Int? //number of attendees that are currently attending
    var openSpotsCount: Int?
    var waitlistCount: Int?
    var chapter: String? //FIXME: Do we need this ?
    var meetupUrlName: String?
    var eventFeature: String?
    
    //Derived Objects
    var timeInString: String?
    var eventMonth: String?
    var eventDay: String?
    var eventDateInMMMDD: String?
    var eventDateForEvent: String?
    var meetupEvent: MeetupEvent?
    var network: Network?
    var eventTags:[String] = []
    
    override init() {
        
        super.init()
        
        //FIXME: Temporary initialization
        name = "Intro to Swift2.0"
        location = "Realm, San Francisco,CA"
        eventDate = NSDate(timeIntervalSinceNow: 20)
        createdAt  = NSDate(timeIntervalSinceNow: 0)
        eventDescription = "Introduction to Swift2.0, basic data types, functions, closures and other interesting topics"
        type = "Mobile"
        attendeeLimit = 50
        rsvpCount = 20
        openSpotsCount = 30
        waitlistCount = 0
        chapter = "SFO"
        eventFeature = "iOS"
        
        //Derived objects temporary initialization
        eventMonth = "MAR"
        eventDay = "2"
        eventTags.append("iOS")
        eventTags.append("Mobile")
        
    }
    

    init(object: PFObject) {
        
        super.init()
        objectId = object.objectId as String!
        name = object["title"] as? String
        location = object["location"] as? String
        //eventDate = object["event_date"] as? NSDate
        createdAt  = object["createdAt"] as? NSDate
        eventDescription = object["eventDescription"] as? String
        type = object["type"] as? String
        attendeeLimit = 50 //FIXME: object["attendee_limit"] as? Int
        rsvpCount = object["subscribe_count"] as? Int //FIXME: Should we have a separate name or use subscribe_count
        chapter = object["chapter"] as? String
        eventDateString = object["event_date"] as? String
        
        if object.objectForKey("network") != nil{
            self.network = Network(object: (object.objectForKey("network") as? PFObject)!)
            chapter = self.network?.title
            meetupUrlName = self.network!.meetupUrlName
        }
        
        if object.objectForKey("feature") != nil {
            let feature = Feature(object: (object.objectForKey("feature") as? PFObject!)!)
            self.eventFeature = feature.title
        }
        
        eventTags = (object["event_tags"] as? [String])!
        setDerivedValues()
    }
    
    func setDerivedValues() {
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd hh:mm:ss a"
        let date = dateFormatter.dateFromString(self.eventDateString!)
        
        dateFormatter.dateFormat = "MMM dd, hh:mma"
        if let dateFound =  date{
            eventDateInMMMDD = dateFormatter.stringFromDate(dateFound)
        }else{
            eventDateInMMMDD = ""
        }
        
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss zzz"
        if let dateFound =  date{
            eventDateForEvent = dateFormatter.stringFromDate(dateFound)
        }else{
            eventDateForEvent = ""
        }

        eventMonth = date?.month
        eventDay = date?.day        
        
        if rsvpCount > attendeeLimit {
            waitlistCount = rsvpCount! - attendeeLimit!
            openSpotsCount = 0
        }
        else {
            waitlistCount = 0
            openSpotsCount = attendeeLimit! - rsvpCount!
        }
    }
    
}

//Meetup Related
extension Event{
    
    func fetchMeetupEvent(successCallback: (MeetupEvent) -> Void){
        MeetupAPI.sharedInstance.fetchEvent(["hey":"test"], successCallback: successCallback)
    }
    
    func fetchEventRsvps(successCallback: [MeetupMember] -> Void){
        MeetupAPI.sharedInstance.fetchEventRsvps(["hey":"test"], successCallback: successCallback)
    }
    
}


