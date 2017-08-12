//
//  BirthdayViewController.swift
//  Birthday
//
//  Created by admin on 12/08/2017.
//  Copyright © 2017 theteam247.com. All rights reserved.
//

import UIKit

class BirthdayViewController: UIViewController {

    @IBOutlet weak var birthdayLabel: UILabel!
    @IBOutlet weak var nextTriggerTimeLabel: UILabel!
    @IBOutlet weak var remainingLabel: UILabel!

    var birthday: Date?
    var alertTime: Date?
    var nextTriggerTime: Date?
    var timer: Timer?
    
    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    override func viewWillAppear(_ animated: Bool) {
        reloadData()
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        startCountDown()
    }
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        stopCountDown()
    }

    
    // MARK: - Interaction Event Handler
    
    @IBAction func editButtonClicked(_ sender: Any) {
        let ud = UserDefaults.standard
        if let birthday = ud.value(forKey: kUserDefaultKey_Birthday) as? Date,
            let alertTime = ud.value(forKey: kUserDefaultKey_AlertTime)  as? Date {
            if let vc = BirthdayCreationViewController.storyboardInstance(birthday: birthday, alertTime: alertTime) {
                let nav = UINavigationController(rootViewController: vc)
                present(nav, animated: true, completion: nil)
            }
        }
    }
    
    // MARK: - Private Method
    
    func reloadData() {
        
        let ud = UserDefaults.standard
        if let birthday = ud.value(forKey: kUserDefaultKey_Birthday) as? Date,
            let alertTime = ud.value(forKey: kUserDefaultKey_AlertTime)  as? Date {
            self.birthday = birthday
            self.alertTime = alertTime
            self.nextTriggerTime = DateUtil.getNextBirthdayTriggerTime(from: birthday, alertTime: alertTime)
            
            birthdayLabel.text = DateUtil.birthdayTimeString(from: birthday)
            nextTriggerTimeLabel.text = DateUtil.nextTriggerTimeString(from: nextTriggerTime)
            
        }else {
            if let vc = BirthdayCreationViewController.storyboardInstance(birthday: nil, alertTime: nil) {
                let nav = UINavigationController(rootViewController: vc)
                present(nav, animated: true, completion: nil)
            }
        }
        
    }
    func startCountDown() {
        if timer == nil {
            timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(countDownDate), userInfo: nil, repeats: true)
        }
    }
    func stopCountDown() {
        if timer != nil {
            timer?.invalidate()
            timer = nil
        }
    }
    
    func countDownDate() {
        if let nextTriggerTime = nextTriggerTime {
            let currentDate = Date()
            if currentDate.compare(nextTriggerTime) != .orderedAscending {
                stopCountDown()
                reloadData()
                startCountDown()
                return
            }
            
            let diffDateComponents = Calendar.current.dateComponents([.day, .hour, .minute, .second], from: currentDate, to: nextTriggerTime)
            if let days = diffDateComponents.day,
                let hours = diffDateComponents.hour,
                let mins = diffDateComponents.minute,
                let seconds = diffDateComponents.second {
                
                let daysUnit = days == 1 ? "day" : "days"
                let hoursUnit = hours == 1 ? "hour" : "hours"
                let minsUnit = mins == 1 ? "min" : "mins"
                let secondsUnit = seconds == 1 ? "sencond" : "seconds"
                let countdownText = "\(days) \(daysUnit) \(hours) \(hoursUnit) \(mins) \(minsUnit) \(seconds) \(secondsUnit) "
                remainingLabel.text = countdownText
            }
        }

    }
}
