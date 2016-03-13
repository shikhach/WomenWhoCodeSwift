//
//  EventCell2.swift
//  WomenWhoCode
//
//  Created by Prasanthi Relangi on 3/12/16.
//  Copyright © 2016 WomenWhoCode. All rights reserved.
//

import UIKit
import Parse

class EventCell2: UITableViewCell {
    
    
    @IBOutlet weak var eventImageView: UIImageView!
    
    
    @IBOutlet weak var eventTitle: UILabel!
    
    @IBOutlet weak var eventDate: UILabel!
    
    @IBOutlet weak var eventLocation: UILabel!
    
    @IBOutlet weak var eventDescription: UILabel!
    
    @IBOutlet weak var eventTag1: UILabel!
    
    @IBOutlet weak var eventTag2: UILabel!
    
    @IBOutlet weak var rsvpLabel: UILabel!
    @IBOutlet weak var eventSpots: UILabel!
    @IBOutlet weak var rsvpConfirmedLabel: UILabel!
    
    var eventObjectId:String?
    var rsvpd: Bool = false
    
    var event: Event! {
        didSet {
            eventTitle.text = event.name
            eventLocation.text = event.location
            eventDate.text = event.eventDateString
            eventDescription.text = event.eventDescription
            eventTag1.text = event.eventTags[1]
            eventTag2.text = event.eventTags[0]
            eventObjectId = event.objectId
            
            //Display waitlist count or openSpots
            if (event.waitlistCount != 0) {
                eventSpots.text = " \(event.waitlistCount!) waitlisted"
            }
            else {
                eventSpots.text = " \(event.openSpotsCount!) spots left"
            }
            
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        eventTag1.layer.cornerRadius = 10
        eventTag1.clipsToBounds = true
        
        eventTag2.layer.cornerRadius = 10
        eventTag2.clipsToBounds = true
        
    }
    
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    func attributedText(string: String)->NSAttributedString{
        
        let attributedString = NSMutableAttributedString(string: string, attributes: [NSFontAttributeName:UIFont.systemFontOfSize(15.0)])
        
        let boldFontAttribute = [NSFontAttributeName: UIFont.boldSystemFontOfSize(15.0)]
        
        // Part of string to be bold
        let range1 = NSRange(location: 4, length: 10)//string.rangeOfString("RSVP: YES") as? NSRange
        attributedString.addAttributes(boldFontAttribute, range: range1)

        return attributedString
    }
    
    
    @IBAction func onRSVP(sender: AnyObject) {
        
        rsvpd = !rsvpd
        
        let loggedInUser = "h0VjEs2aql" //FIXME: Change this to get the current User
        let userEvent = PFObject(className:"UserEvents")
        
        
        let predicate = NSPredicate(format:"event_id == '\(eventObjectId!)' AND user_id == '\(loggedInUser)'")
        let query = PFQuery(className: "UserEvents", predicate: predicate)
        
        if rsvpd == true {
            rsvpConfirmedLabel.hidden = false
            rsvpConfirmedLabel.textAlignment = .Center
            rsvpConfirmedLabel.attributedText = attributedText("Your RSVP: YES")
            rsvpLabel.hidden = true
            eventSpots.hidden = true
        }
        else {
            rsvpConfirmedLabel.hidden = true
            rsvpLabel.hidden = false
            eventSpots.hidden = false
        }
        
        //FIXME: prelangi : Refactor this code!!
        query.findObjectsInBackgroundWithBlock {
            (objects: [PFObject]?, error: NSError?) -> Void in
            
            if error == nil {
                // The find succeeded.
                print("Successfully retrieved \(objects!.count) profiles.")
                
                if objects!.count == 0 {
                    userEvent["user_id"] = loggedInUser
                    // Add a relation between the Post and Comment
                    userEvent["event_id"] = self.eventObjectId
                    userEvent["rsvpd"] = self.rsvpd
                    
                    // This will save both myPost and myComment
                    userEvent.saveInBackground()
                    
                }
                else {
                    if let objects = objects {
                        for object in objects {
                            object["rsvpd"] = self.rsvpd
                            
                            object.saveInBackground()
                        }
                    }
                }
            } else {
                // Log details of the failure
                print("Error: \(error!)")
                
                
                
            }
        }
        
        
    }
    
    
}
