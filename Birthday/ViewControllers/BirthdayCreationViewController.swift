//
//  BirthdayCreationViewController.swift
//  Birthday
//
//  Created by admin on 12/08/2017.
//  Copyright © 2017 theteam247.com. All rights reserved.
//

import UIKit

class BirthdayCreationViewController: UIViewController {

    @IBOutlet weak var birthdayLabel: UILabel!
    @IBOutlet weak var alertTimeLabel: UILabel!
    @IBOutlet weak var birthdayButton: UIButton!
    @IBOutlet weak var alertButton: UIButton!
    @IBOutlet weak var doneButton: UIBarButtonItem!
    
    var birthday: Date?
    var alertTime: Date?
    
    // MARK: - Life Cycle
  
    static func storyboardInstance(birthday: Date?, alertTime: Date?) -> BirthdayCreationViewController?{
        let storyboard = UIStoryboard(name: "Main",bundle: nil)
        if let vc = storyboard.instantiateViewController(withIdentifier: String(describing: self)) as?  BirthdayCreationViewController {
            vc.birthday = birthday
            vc.alertTime = alertTime
            return vc
        }
        return nil
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadData()
    }

    
    // MARK: - Interaction Event Handler
   
    @IBAction func setupBirthdayButtonClicked(_ sender: Any) {
        
        DatePickerPopView(date: self.birthday, type: .date).show(inView: self.navigationController?.view, chooseCompleted: { date in
            self.birthday = date
            self.birthdayButton.setTitle(DateUtil.birthdayTimeString(from: date), for: .normal)
            self.refreshDoneButtonState()
        }, dismissCompleted: nil)
    }
    
    @IBAction func addAlertButtonClicked(_ sender: Any) {
        
        DatePickerPopView(date: self.alertTime, type: .time).show(inView: self.navigationController?.view, chooseCompleted: { date in
            self.alertTime = date
            self.alertButton.setTitle(DateUtil.alertTimeString(from: date), for: .normal)
            self.refreshDoneButtonState()
        }, dismissCompleted: nil)
    }
    
    @IBAction func done(_ sender: Any) {
        guard let birthday = birthday, let alertTime = alertTime else { return }
        let ud = UserDefaults.standard
        ud.setValue(birthday, forKey: kUserDefaultKey_Birthday)
        ud.setValue(alertTime, forKey: kUserDefaultKey_AlertTime)
        ud.synchronize()
        
        dismiss(animated: true) {
            
            if let date = DateUtil.getBirthdayAlertTime(from: birthday, alertTime: alertTime) {
                if #available(iOS 10.0, *) {
                    NotificationManager.shared.removeAllUserNotificationsForiOS10()
                    NotificationManager.shared.addUserNotificationForiOS10(date: date, type: .everyYear)
                } else {
                    NotificationManager.shared.removeAllNotificationsForiOS9()
                    NotificationManager.shared.addUserNotificationForiOS9(date: date, type: .everyYear)
                }
            }
        }
    }
    
    // MARK: - Private Method
    
    func loadData() {
        
        if let birthday = birthday,
            let alertTime = alertTime {
            birthdayButton.setTitle(DateUtil.birthdayTimeString(from: birthday), for: .normal)
            alertButton.setTitle(DateUtil.alertTimeString(from: alertTime), for: .normal)
        }
        refreshDoneButtonState()
    }
    
    func refreshDoneButtonState() {
        self.doneButton.isEnabled = (birthday != nil && alertTime != nil)
    }
}

