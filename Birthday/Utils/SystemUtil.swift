//
//  SystemUtil.swift
//  Birthday
//
//  Created by admin on 12/08/2017.
//  Copyright © 2017 theteam247.com. All rights reserved.
//

import UIKit

class SystemUtil: NSObject {

    static func jumpToSettingPage() {
        let url = URL.init(string:UIApplicationOpenSettingsURLString)!
        if UIApplication.shared.canOpenURL(url){
            if #available(iOS 10.0, *) {
                UIApplication.shared.open(url, options:[:], completionHandler: nil)
            } else {
                UIApplication.shared.openURL(url)
            }
        }
    }
    
    static func showHappyVC() {
        if let vc = HappyAnimationViewController.storyboardInstance() {
            UIApplication.shared.keyWindow?.rootViewController?.present(vc, animated: true, completion: nil)
        }
        
    }

}
