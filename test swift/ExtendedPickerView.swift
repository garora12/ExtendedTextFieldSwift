//
//  ExtendedPickerView.swift
//  E-Ticketing
//
//  Created by Kanwarpal Singh on 2/19/16.
//  Copyright © 2016 Navroz Singh. All rights reserved.
//

import UIKit

protocol ExtendedPickerViewDelegate{
    func extendedPickerViewDidValueSelected(selectedValue:NSMutableArray,obj:ExtendedPickerView)
    func extendedPickerViewDidCancel(obj:ExtendedPickerView)
}

class ExtendedPickerView: UIView , UIPickerViewDataSource,UIPickerViewDelegate{
    
    static let sharedInstance = ExtendedPickerView()
    
    var options     =   NSArray()
    var valueHolder :   ExtendedTextField!
    var picker      :   UIPickerView!
    
    var delegate    :   ExtendedPickerViewDelegate! = nil

    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
    }

    override init(frame: CGRect) {
        //Do whatever you want here
        super.init(frame: frame)
    }
    
    func addPicker(values: NSArray){
        picker                  =   UIPickerView()
        picker.frame            =   CGRectMake(0, 44, self.frame.size.width, 216)
        picker.delegate         =   self
        picker.dataSource       =   self
        picker.backgroundColor  =   UIColor.whiteColor()
        self.addSubview(picker)
        
        self.options = values
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
        self.delegate?.extendedPickerViewDidCancel(self)
    }
    
    func doneClicked(){
        let selectedComponentValues = NSMutableArray()
        for i in 0 ..< self.options.count  {
            let currentComponteValues = self.options[i] as! NSArray
            let selectedValue = currentComponteValues[picker.selectedRowInComponent(i)]
            selectedComponentValues.addObject(selectedValue)
        }
        
        self.delegate?.extendedPickerViewDidValueSelected(selectedComponentValues,obj: self)
    }
    
    func numberOfComponentsInPickerView(colorPicker: UIPickerView) -> Int {
        return self.options.count
    }
    
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return self.options[component].count
    }
    
    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String?
    {
        return self.options[component][row] as? String
    }
}

extension ExtendedPickerView {
    func showPickerOnViewWithOptions(values:NSArray, onView:UIViewController, forField:AnyObject){
        forField.resignFirstResponder()
        self.frame = CGRectMake(0, onView.view.frame.size.height, onView.view.frame.size.width, 260)
        
        self.addPicker(values)
        self.addToolBar()
        
        let options: UIViewAnimationOptions = [.CurveEaseInOut]
        UIView.animateWithDuration(1, delay: 0, usingSpringWithDamping: 0, initialSpringVelocity: 0, options: options, animations: { () -> Void in
            
            self.frame = CGRectMake(0, onView.view.frame.size.height - 260, onView.view.frame.size.width, 260)
            
            }, completion: nil)
        
        
        onView.view.addSubview(self)
    }
}


