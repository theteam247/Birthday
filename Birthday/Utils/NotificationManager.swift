//
//  NotificationManager.swift
//  Birthday
//
//  Created by admin on 12/08/2017.
//  Copyright © 2017 theteam247.com. All rights reserved.
//

import UIKit
import UserNotifications

enum NotificatonRepetType {
    case everyYear
}

private let kNotificationAlertTitle = "Happy birthday!!!"
private let kNotificationAlertBody = "Best wishes to you!"
private let kSoundName = "happy.m4a"

class NotificationManager: NSObject {
    static let shared = NotificationManager()
    private override init() {
    }
    
    func addUserNotificationForiOS9(date: Date, type: NotificatonRepetType) {
        UIApplication.shared.registerUserNotificationSettings(UIUserNotificationSettings(types:[.sound, .alert, .badge], categories: nil))
        let notification = UILocalNotification()
        notification.fireDate = date
        switch type {
        case .everyYear:
            notification.repeatInterval = .year
        }
        notification.alertTitle = kNotificationAlertTitle
        notification.alertBody = kNotificationAlertBody
        notification.applicationIconBadgeNumber = 1
        notification.soundName = kSoundName
        UIApplication.shared.scheduleLocalNotification(notification)
    }
    
    func removeAllNotificationsForiOS9() {
        UIApplication.shared.cancelAllLocalNotifications()
    }
    
    // MARK: - Public Method
    @available(iOS 10.0, *)
    func addUserNotificationForiOS10(date: Date, type: NotificatonRepetType) {

        UNUserNotificationCenter.current().getNotificationSettings(completionHandler: { (settings) in
            if settings.authorizationStatus == .notDetermined {
                
                self.requestUserNotificationAuthorization {
                    self.realAddUserNotifiaction(for: date, type: type)
                }
                
            }else if settings.authorizationStatus == .denied{
                
                self.presentRquestAuthorAlert()
                
            }else if settings.authorizationStatus == .authorized {
                
                self.realAddUserNotifiaction(for: date, type: type)
            }
        })
    
    }
    @available(iOS 10.0, *)
    func removeAllUserNotificationsForiOS10() {
        UNUserNotificationCenter.current().removeAllPendingNotificationRequests()
    }
    

    
    // MARK: - Private Method
    @available(iOS 10.0, *)
    func requestUserNotificationAuthorization(completionHandler: @escaping () -> ()) {
        
        UNUserNotificationCenter.current().requestAuthorization(options: [.badge,.alert,.sound]) { (granted, error) in
            if granted {
                print("authorization succeed!")
                completionHandler()
            }else{
                self.presentRquestAuthorAlert()
            }
        }
    }

    func presentRquestAuthorAlert() {
        
        DispatchQueue.main.async {
            let alert = UIAlertController(title: "Notification authorization failed", message: "Please open the notification permissions on the settings page", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
            alert.addAction(UIAlertAction(title: "Setting", style: .default, handler: {
                _ in
                SystemUtil.jumpToSettingPage()
            }))
            UIApplication.shared.keyWindow?.rootViewController?.present(alert, animated: true, completion: nil)
        }
        
    }
    @available(iOS 10.0, *)
    func realAddUserNotifiaction(for date: Date, type: NotificatonRepetType) {
        let content = generateNotificationContent()
        switch type {
        case .everyYear:
            addNotificationRepeatEveryYear(identifier: date.description, date: date, content: content)
        }
    }

    @available(iOS 10.0, *)
    func addNotificationRepeatEveryYear(identifier: String, date: Date, content: UNNotificationContent) {
        let dateComponents = Calendar.current.dateComponents([.month,.day,.hour,.minute,.second], from: date)
        let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: true)
        addUserNotification(identifier: identifier, trigger: trigger, content: content)
    }
    
    @available(iOS 10.0, *)
    func generateNotificationContent() -> UNNotificationContent{
        let content = UNMutableNotificationContent()
        content.title = kNotificationAlertTitle
        content.body = kNotificationAlertBody
        content.sound = UNNotificationSound(named: kSoundName)
        content.badge = 1
        return content
    }
    
    @available(iOS 10.0, *)
    func addUserNotification(identifier: String, trigger: UNCalendarNotificationTrigger, content: UNNotificationContent) {
        let request = UNNotificationRequest(identifier: identifier, content: content, trigger: trigger)
        UNUserNotificationCenter.current().add(request) { error in
            if error == nil {
                print("Time Interval Notification scheduled: \(identifier) for event:\(identifier)")
            }
        }
    }  
}
@available(iOS 10.0, *)
extension NotificationManager: UNUserNotificationCenterDelegate {
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        
        SystemUtil.showHappyVC()
        
        completionHandler([])
    }
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        
        UNUserNotificationCenter.current().removeAllDeliveredNotifications()
        SystemUtil.showHappyVC()
        completionHandler()
    }
    
}
