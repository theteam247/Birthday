//
//  DatePickerPopView.swift
//  Birthday
//
//  Created by admin on 12/08/2017.
//  Copyright © 2017 theteam247.com. All rights reserved.
//

import UIKit
import SnapKit

typealias DateChooseCompletedBlock = (Date?) -> Void
typealias DismissCompletedBlock = () -> Void

private let kContentViewMaxHeight: CGFloat = 280
class DatePickerPopView: UIView {

    var contentViewBottomConstraint: Constraint?
    
    var dateChooseCompletedBlock: DateChooseCompletedBlock?
    var dismissCompletedBlock: DismissCompletedBlock?
    
    var initDate: Date
    var pickerType: UIDatePickerMode
    
    lazy var contentHeight: CGFloat = {
        return  kContentViewMaxHeight
    }()
    
    lazy var backgroundView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(white: 0, alpha: 0.3)
        view.alpha = 0
        view.isUserInteractionEnabled = true
        view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(tapBackgroundView)))
        return view
    }()
    
    lazy var contentView: UIView = {
        let view = UIView()
        view.addSubview(self.pickerView)
        
        self.pickerView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
        return view
    }()
    
    lazy var pickerView: DatePickerView = {
        let pickerView = DatePickerView(date: self.initDate, type: self.pickerType)
        pickerView.delegate = self
        pickerView.backgroundColor = UIColor.white
        return pickerView
    }()

    // MARK: - Life Cycle
    init(date: Date?, type: UIDatePickerMode) {
        if date == nil {
            self.initDate = Date()
        }else {
            self.initDate = date!
        }
        self.pickerType = type
        super.init(frame: UIScreen.main.bounds)
        
        setupSubviews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupSubviews() {
        addSubview(backgroundView)
        addSubview(contentView)
        
        backgroundView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
        contentView.snp.makeConstraints { (make) in
            make.left.right.equalToSuperview()
            make.height.equalTo(contentHeight)
            self.contentViewBottomConstraint = make.bottom.equalTo(self.snp.bottom).offset(self.contentHeight).constraint
        }
        layoutIfNeeded()
    }
    
    func show(inView view: UIView?, chooseCompleted: @escaping DateChooseCompletedBlock, dismissCompleted: DismissCompletedBlock?) {
        
        self.dateChooseCompletedBlock = chooseCompleted
        self.dismissCompletedBlock = dismissCompleted
        
        if self.superview == nil {
            if let v = view {
                v.addSubview(self)
            }else {
                let window = UIApplication.shared.keyWindow
                window?.addSubview(self)
            }
            UIView.animate(withDuration: 0.25) {
                self.backgroundView.alpha = 1
                self.contentViewBottomConstraint?.update(offset: 0)
                self.layoutIfNeeded()
            }
        }
    }
    
    func dismiss(completed: (() -> Void)? = nil) {
        if self.superview != nil {
            
            UIView.animate(withDuration: 0.25, animations: {
                self.backgroundView.alpha = 0
                self.contentViewBottomConstraint?.update(offset: self.contentHeight)
                self.layoutIfNeeded()
            }, completion: { (_) in
                
                if let block = completed {
                    block()
                }
                self.removeFromSuperview()
            })
        }
    }

    func tapBackgroundView() {
        dismiss(completed: self.dismissCompletedBlock)
    }
}

extension DatePickerPopView: DatePickerViewDelegate {
    
    func cancelPick(datePickerView: DatePickerView) {
        self.dismiss(){

            if let block = self.dismissCompletedBlock {
                block()
            }
            self.dateChooseCompletedBlock = nil
            self.dismissCompletedBlock = nil
        }
    }
    func confirmPick(datePickerView: DatePickerView, selectedDate: Date) {
        self.dismiss(){
            if let block = self.dateChooseCompletedBlock {
                block(selectedDate)
            }
            self.dateChooseCompletedBlock = nil
            self.dismissCompletedBlock = nil
        }
    }
}
