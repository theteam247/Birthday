//
//  DatePickerView.swift
//  Birthday
//
//  Created by admin on 12/08/2017.
//  Copyright © 2017 theteam247.com. All rights reserved.
//

import UIKit
import SnapKit
import Toast_Swift

protocol DatePickerViewDelegate: NSObjectProtocol {
    func cancelPick(datePickerView: DatePickerView)
    func confirmPick(datePickerView: DatePickerView, selectedDate: Date)
}

private let kDateToolbarHeight: CGFloat = 40

class DatePickerView: UIView {
    
    weak var delegate: DatePickerViewDelegate?
    
    var date: Date {
        
        didSet {
            self.datePicker.setDate(self.date, animated: false)
            self.setNeedsLayout()
            self.layoutIfNeeded()
        }
    }

    var pickerType: UIDatePickerMode
    
    lazy var datePicker: UIDatePicker = {
        let picker = UIDatePicker()
        picker.datePickerMode = self.pickerType
        picker.date = self.date
        return picker
    }()
    
    lazy var toolbar: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(white: 0.95, alpha: 1)
        
        let upLine = UIView()
        upLine.backgroundColor = UIColor.lightGray
        view.addSubview(upLine)
        
        let deleteBtn = UIButton()
        deleteBtn.setTitle("Cancel", for: .normal)
        deleteBtn.setTitleColor(UIColor.gray, for: .normal)
        deleteBtn.titleLabel?.font = UIFont.systemFont(ofSize: 15)
        deleteBtn.addTarget(self, action: #selector(cancelBtnClicked), for: .touchUpInside)
        view.addSubview(deleteBtn)
        
        let confirmBtn = UIButton()
        confirmBtn.setTitle("Confirm", for: .normal)
        confirmBtn.setTitleColor(UIColor.red, for: .normal)
        confirmBtn.titleLabel?.font = UIFont.systemFont(ofSize: 15)
        confirmBtn.addTarget(self, action: #selector(confirmBtnClicked), for: .touchUpInside)
        view.addSubview(confirmBtn)
        
        upLine.snp.makeConstraints({ (make) in
            make.left.right.top.equalTo(view)
            make.height.equalTo(0.5)
        })
        deleteBtn.snp.makeConstraints({ (make) in
            make.left.equalTo(view).offset(10)
            make.top.bottom.equalTo(view)
        })
        confirmBtn.snp.makeConstraints({ (make) in
            make.right.equalTo(view).offset(-10)
            make.top.bottom.equalTo(view)
        })
        
        return view
    }()
   
    // MARK: - Life Cycle
    init(date: Date = Date(), type: UIDatePickerMode) {
        self.date = date
        self.pickerType = type
        super.init(frame: CGRect.zero)
        
        setupSubviews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupSubviews(){
        backgroundColor = UIColor.white
        addSubview(toolbar)
        addSubview(datePicker)
        
        toolbar.snp.makeConstraints { (make) in
            make.left.top.right.equalTo(self)
            make.height.equalTo(kDateToolbarHeight)
        }
        
        datePicker.snp.makeConstraints { (make) in
            make.bottom.equalToSuperview().offset(-10)
            make.centerX.equalToSuperview()
        }
        layoutIfNeeded()
    }
    
    // MARK: - Interaction Event Handler
    func cancelBtnClicked() {
        self.delegate?.cancelPick(datePickerView: self)
    }
    func confirmBtnClicked() {
        self.delegate?.confirmPick(datePickerView: self, selectedDate: datePicker.date)
    }

}
