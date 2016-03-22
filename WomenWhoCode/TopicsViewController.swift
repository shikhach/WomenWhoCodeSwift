//
//  TopicsViewController.swift
//  WomenWhoCode
//
//  Created by Prasanthi Relangi on 2/29/16.
//  Copyright © 2016 WomenWhoCode. All rights reserved.
//

import UIKit

class TopicsViewController: UIViewController {
    
    @IBOutlet var tableView: UITableView!
    var topics :[Feature] = []
    var subscribed_topics :[Feature] = []
    var recommended_topics :[Feature] = []
    var other_topics :[Feature] = []
    var section_headers = ["Subscribed", "Recommended", "All Topics"]
    
    var subscription : [Subscribed] = []
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.dataSource = self
        tableView.delegate = self
        tableView.estimatedRowHeight = 320
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.separatorStyle = .None
        getTopics()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func getTopics()
    {
        ParseAPI.sharedInstance.getFeatures { (feature, error) -> () in
            self.topics = feature!
            self.getSubscribed()
            self.tableView.reloadData()
        }
    }
    
    func getSubscribed()
    {
        ParseAPI.sharedInstance.getSubscriptions { (subscribed, error) -> () in
            self.subscription = subscribed!
            self.tableView.reloadData()
            self.setSubscribedTopics()
        }
        
    }
    
    func showChannel(topic: Feature){
        //Chat Page
        print("Topic: \(topic.title)")
        let chatStoryboard = UIStoryboard(name: "Chat", bundle: nil)
        let chatViewController = chatStoryboard.instantiateViewControllerWithIdentifier("ChatViewController") as! ChatViewController
        chatViewController.channelId = topic.slackChannelId
        chatViewController.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(chatViewController, animated: true)
    }
    
    func setSubscribedTopics() {
        for(var i = 0 ; i < topics.count; i++) {
            var added = false
            if ((topics[i].auto_subscribe != nil && topics[i].auto_subscribe!)) {
                subscribed_topics.append(topics[i])
                continue
            }
            for (var j = 0 ; j < subscription.count; j++) {
                if(subscription[j].feature_id == topics[i].objectId && subscription[j].subscribe != nil && subscription[j].subscribe!) {
                    subscribed_topics.append(topics[i])
                    added = true
                } else  if(subscription[j].feature_id == topics[i].objectId && subscription[j].recommended != nil && subscription[j].recommended!) {
                    //print("Topics title: \(topics[i].title!) hexcolor: \(topics[i].hex_color!)")
                    recommended_topics.append(topics[i])
                    added = true
                }
            }
            if(!added) {
                other_topics.append(topics[i])
            }
        }
        print("subscribed: \(subscribed_topics.count), recommended:  \(recommended_topics.count),other:  \(other_topics.count)")
        tableView.reloadData()
    }
}

extension TopicsViewController: UITableViewDataSource, UITableViewDelegate{
    
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("TopicCell", forIndexPath: indexPath) as! TopicCell
        if(indexPath.section == 0) {
            cell.feature = subscribed_topics[indexPath.row]
            cell.followImage.hidden = true
            
        } else if(indexPath.section == 1) {
            cell.feature = recommended_topics[indexPath.row]
            cell.followImage.hidden = false
            
        } else {
            cell.feature = other_topics[indexPath.row]
            cell.followImage.hidden = false
            
        }
        
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
      //  showChannel(topics[indexPath.row]) //FixMe: I should move out of here and within the topic details page. Also without section this won't work. Needs some work here
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        if(section == 0)
        {
            return subscribed_topics.count
        } else if section == 1 {
            return recommended_topics.count
        }
        else {
            return other_topics.count
        }
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 3
    }
    
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 40
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 80
    }
    
    
    func tableView(tableView: UITableView,
                   titleForHeaderInSection section: Int) -> String? {
        return section_headers[section]
    }
    
    
    
}


