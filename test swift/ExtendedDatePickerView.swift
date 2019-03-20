//
//  ExtendedDatePickerView.swift
//  test swift
//
//  Created by Kanwarpal Singh on 09/06/16.
//  Copyright © 2016 Kanwarpal Singh. All rights reserved.
//

import UIKit

protocol ExtendedDatePickerViewDelegate{
    func extendedDatePickerViewDidValueSelected(selectedDate:NSDate,obj:ExtendedDatePickerView)
    func extendedDatePickerViewDidCancel(obj:ExtendedDatePickerView)
}

class ExtendedDatePickerView: UIView{
    static let sharedInstance = ExtendedPickerView()
    
    var options     =   NSArray()
    var valueHolder :   ExtendedTextField!
    var datePicker  :   UIDatePicker = UIDatePicker()
    
    var delegate    :   ExtendedDatePickerViewDelegate! = nil
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
    }
    
    override init(frame: CGRect) {
        //Do whatever you want here
        super.init(frame: frame)
    }
    
    func addDatePicker(){
        
        // setting properties of the datePicker
        self.datePicker.frame = CGRectMake(0, 44, self.frame.width, 216)
        self.datePicker.timeZone = NSTimeZone.localTimeZone()
        self.datePicker.backgroundColor = UIColor.whiteColor()
        self.datePicker.layer.cornerRadius = 5.0
        self.datePicker.layer.shadowOpacity = 0.5
        
        // add DataPicker to the view
        self.addSubview(self.datePicker)
    }
    
    func addToolBar(){
        let toolbar     =   UIToolbar()
        toolbar.frame   =   CGRectMake(0, 0, self.frame.size.width, 44)
        toolbar.sizeToFit()
        toolbar.backgroundColor = UIColor.redColor()
        self.addSubview(toolbar)
        
        let cancelButton    =   UIBarButtonItem(title: "Cancel", style: UIBarButtonItemStyle.Plain, target: self, action: #selector(self.cancelClicked))
        
        let flexBarButton   =   UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.FlexibleSpace, target: self, action: nil)
        
        let doneButton      =   UIBarButtonItem(title: "Done", style: UIBarButtonItemStyle.Plain, target: self, action: #selector(self.doneClicked))
        
        var items = [UIBarButtonItem]()
        items.append(cancelButton)
        items.append(flexBarButton)
        items.append(doneButton)
        
        toolbar.items = items
    }
    
    func cancelClicked(){
        self.delegate?.extendedDatePickerViewDidCancel(self)
    }
    
    func doneClicked(){
        self.delegate?.extendedDatePickerViewDidValueSelected(self.datePicker.date, obj: self)
    }    
}

extension ExtendedDatePickerView {
    func showDatePickerOnViewWithOptions(onView:UIViewController, forField:AnyObject){
        forField.resignFirstResponder()
        self.frame = CGRectMake(0, onView.view.frame.size.height, onView.view.frame.size.width, 260)
        
        self.addDatePicker()
        self.addToolBar()
        
        let options: UIViewAnimationOptions = [.CurveEaseInOut]
        UIView.animateWithDuration(1, delay: 0, usingSpringWithDamping: 0, initialSpringVelocity: 0, options: options, animations: { () -> Void in
            
            self.frame = CGRectMake(0, onView.view.frame.size.height - 260, onView.view.frame.size.width, 260)
            
            }, completion: nil)
        
        
        onView.view.addSubview(self)
    }
}

