//
//  NotifcationViewController.swift
//  OnceADayMotivate
//
//  Created by Christopher Meyer on 4/23/20.
//  Copyright © 2020 Christopher Meyer. All rights reserved.
//

import UIKit
import Firebase
import FirebaseFirestore
import FirebaseFirestoreSwift
import UserNotifications

class NotifcationViewController: UIViewController {


    @IBOutlet weak var timeSelecter: UIDatePicker!
    
    @IBOutlet weak var setReminderButton: UIButton!
    
    let notificationCenter = UNUserNotificationCenter.current()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let startDate = Date().noon
        timeSelecter.setDate(startDate, animated: false)
        
        title = "Notifications"
        
        notificationCenter.getNotificationSettings { (settings) in
          if settings.authorizationStatus != .authorized {
            print("Notifications Not Allowed")
            
          }
          else {
            print(settings)
            }
        }
    }
    
    
    @IBAction func setReminderPressed(_ sender: Any) {
        let selectedDate = timeSelecter.date
        print(timeSelecter.date.TimeSetup)
        scheduleNotification(date: selectedDate, center: notificationCenter)
        
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

extension Date {
    var TimeSetup: String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "hh:mm a"
        return dateFormatter.string(from: self)
    }
}

func scheduleNotification(date: Date, center: UNUserNotificationCenter){
    // Create the contexnt of the notification
    let notifcation = UNMutableNotificationContent()
    notifcation.title = "Once A Day: Motivate"
    notifcation.body = "Get Your Daily Quote"
    notifcation.sound = UNNotificationSound.default
    
    // Create the trigger of when it will run
    let triggerDaily = Calendar.current.dateComponents([.hour, .minute, .second], from: date)
    let trigger = UNCalendarNotificationTrigger(dateMatching: triggerDaily, repeats: true)
    
    // Schedule the notification
    let identifier = "UYLLocalNotification"
    let request = UNNotificationRequest(identifier: identifier, content: notifcation, trigger: trigger)

    center.add(request, withCompletionHandler: { (error) in
        if let error = error {
            print("Error")
        }
        else {
            print("NotificationAdded")
        }
    })

}

