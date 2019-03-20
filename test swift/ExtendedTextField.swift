//
//  ExtendedTextField.swift
//  E-Ticketing
//
//  Created by Kanwarpal Singh on 2/10/16.
//  Copyright © 2016 Navroz Singh. All rights reserved.
//

//import Foundation

import UIKit

protocol TextFieldCustomDelegate
{
    // cutom delegate methods that can be implemented view controller that conform to protocol
    
    // Called when text field get focus
    func didBegin(currentTextfield: UITextField)
    // Called when text field leave focus
    func didEnd(currentTextfield: UITextField)
    // Called when text field returnd key is pressed
    func returnKey(currentTextfield: UITextField)
}

@IBDesignable class ExtendedTextField: UITextField ,UITextFieldDelegate {

    // defines if there is any limit for text filed
    @IBInspectable internal var sizeLimit: Bool                 =   false
    
    // defines the maximum character limit for text field
    @IBInspectable internal var maxLength: Int                  =   0
    
    // defines the minimum requcired character limit for text field
    @IBInspectable internal var minLength: Int                  =   0
    
    // a refrence to define whether field is phone field, defult is false
    @IBInspectable internal var phone: Bool                     =   false
    
    // define whether to enable phone number formatting like 123-456-7890
    @IBInspectable internal var formatPhone: Bool               =   false
    
    // a refrence to define whether field will open picker on tap
    @IBInspectable internal var pickerType: Bool                =   false
    
    // a refrence to define whether field will open date picker on tap
    @IBInspectable internal var datePickerType: Bool            =   false

    // defines the characters that can be entered in text field
    @IBInspectable internal var allowedCharacters: String       =   ""
    
    // defines all the characters can be entered in text field
    @IBInspectable internal var allowAllCharacters: Bool        =   true
    
    // defines the color to set to text field when validation failed
    @IBInspectable internal var highlightColor: UIColor!
    
    // defines the left padding for text in text field
    @IBInspectable internal var leftPadding: CGFloat            =   0
    
    // defines the right padding for text in text field
    @IBInspectable internal var rightPadding: CGFloat           =   0
    
    // defines the top padding for text in text field
    @IBInspectable internal var topPadding: CGFloat             =   0
    
    // defines the bottom padding for text in text field
    @IBInspectable internal var bottomPadding: CGFloat          =   0
    
    // A refrence to delegate of TextFieldCustomDelegate
    var customDelegate:TextFieldCustomDelegate?
    
    // options value for picker type field
    var options = NSArray()
    
    // defines the text field placeholder color
    @IBInspectable var placeholderColor: UIColor {
        get {
            return UIColor.darkGrayColor()
        }
        set {
            self.attributedPlaceholder = NSAttributedString(string:self.placeholder!,
                                                            attributes:[NSForegroundColorAttributeName: newValue])
        }
    }
    
    // defines the text field border color
    @IBInspectable var borderColor: UIColor {
        get {
            return UIColor(CGColor : layer.borderColor!)
        }
        set {
            layer.borderColor = newValue.CGColor
        }
    }
    
    // defines the text field border width
    @IBInspectable var borderWidth: CGFloat {
        get {
            return layer.borderWidth
        }
        set {
            layer.borderWidth = newValue
        }
    }
    
    // defines the text field corner radius
    @IBInspectable var cornerRadius: CGFloat {
        get {
            return layer.cornerRadius
        }
        set {
            layer.cornerRadius = newValue
            layer.masksToBounds = newValue > 0
        }
    }
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
        self.delegate = self
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }

    func textFieldShouldBeginEditing(textField: UITextField) -> Bool{
        if self.datePickerType || self.pickerType {
            if self.datePickerType{
                let pickerView          =   ExtendedPickerView()
                let currentRootView     =   rootView()
                pickerView.delegate     =   currentRootView as? ExtendedPickerViewDelegate
                pickerView.showPickerOnViewWithOptions(self.options, onView: currentRootView, forField: self)
            }
            else{
                let datePickerView          =   ExtendedDatePickerView()
                let currentRootView         =   rootView()
                datePickerView.delegate     =   currentRootView as? ExtendedDatePickerViewDelegate
                datePickerView.showDatePickerOnViewWithOptions(rootView(), forField: self)
            }
            return false
        }
        return true
    }
    
    func textField(textField: UITextField, shouldChangeCharactersInRange range: NSRange, replacementString string: String) -> Bool {
        
        if string.isEmpty{
            return true
        }
        
        if self.phone{
            return self.processPhoneField(textField, shouldChangeCharactersInRange: range, replacementString: string)
        }
        else{
            return self.processOtherField(textField, shouldChangeCharactersInRange: range, replacementString: string)
        }
    }
    
    func processOtherField(textField: UITextField, shouldChangeCharactersInRange range: NSRange, replacementString string: String) -> Bool {
        
        if self.allowAllCharacters {
            return true;
        }
        
        let charSet =
            NSCharacterSet(charactersInString: self.allowedCharacters)
        let range   =   string.rangeOfCharacterFromSet(charSet)
        
        // range will be nil if no letters is found
        if (range != nil) {
            //print("letters found")
            
            if self.sizeLimit{
                
                if self.maxLength < (self.text?.characters.count)! + 1{
                    return false;
                }
            }
            return true;
            
        }
        else {
            //print("letters not found")
            return false;
        }
    }
    func processPhoneField(textField: UITextField, shouldChangeCharactersInRange range: NSRange, replacementString string: String) -> Bool {
        
        if formatPhone{
            self.maxLength = 12
            if self.maxLength < (self.text?.characters.count)! + 1{
                return false;
            }
        }
        else{
            self.maxLength = 10
            if self.maxLength < (self.text?.characters.count)! + 1{
                return false;
            }
        }
        
        let charSet         =   NSCharacterSet(charactersInString: self.allowedCharacters)
        let rangeOfChar     =   string.rangeOfCharacterFromSet(charSet)
        
        // range will be nil if no letters is found
        if (rangeOfChar != nil && self.formatPhone) {
           // print("letters found")
            let newString = (textField.text! as NSString).stringByReplacingCharactersInRange(range, withString: string)
            let components = newString.componentsSeparatedByCharactersInSet(NSCharacterSet.decimalDigitCharacterSet().invertedSet)
            
            let decimalString = components.joinWithSeparator("") as NSString
            let length = decimalString.length
            let hasLeadingOne = length > 0 && decimalString.characterAtIndex(0) == (1 as unichar)
            
            if length == 0 || (length > 10 && !hasLeadingOne) || length > 11
            {
                let newLength = (textField.text! as NSString).length + (string as NSString).length - range.length as Int
                
                return (newLength > 10) ? false : true
            }
            var index = 0 as Int
            let formattedString = NSMutableString()
            
            if hasLeadingOne
            {
                formattedString.appendString("1 ")
                index += 1
            }
            if (length - index) > 3
            {
                let areaCode = decimalString.substringWithRange(NSMakeRange(index, 3))
                formattedString.appendFormat("%@-", areaCode)
                index += 3
            }
            if length - index > 3
            {
                let prefix = decimalString.substringWithRange(NSMakeRange(index, 3))
                formattedString.appendFormat("%@-", prefix)
                index += 3
            }
            
            let remainder = decimalString.substringFromIndex(index)
            formattedString.appendString(remainder)
            textField.text = formattedString as String
            return false
        }
        else {
            //print("letters not found")
            return true;
        }

    }
    
    //MARK:For padding
    
    override func textRectForBounds(bounds: CGRect) -> CGRect {
        return self.newBounds(bounds)
    }
    
    override func placeholderRectForBounds(bounds: CGRect) -> CGRect {
        return self.newBounds(bounds)
    }
    
    override func editingRectForBounds(bounds: CGRect) -> CGRect {
        return self.newBounds(bounds)
    } 
    
    // set padding
    private func newBounds(bounds: CGRect) -> CGRect {
        let  padding = UIEdgeInsets(top: self.topPadding, left: self.leftPadding, bottom: self.bottomPadding, right: self.rightPadding);
        var newBounds           =   bounds
        newBounds.origin.x      +=  padding.left
        newBounds.origin.y      +=  padding.top
        newBounds.size.height   -=  padding.top + padding.bottom
        newBounds.size.width    -=  padding.left + padding.right
        return newBounds
    }
    
    //MARK: Text field custom delegate
    func textFieldDidBeginEditing(textField: UITextField){
        customDelegate?.didBegin(textField)
    }
    func textFieldDidEndEditing(textField: UITextField) {
        customDelegate?.didEnd(textField)
    }
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        customDelegate?.returnKey(textField)
        textField.resignFirstResponder()
        return true
    }
    
    func rootView() -> UIViewController{
        let appDelegate  = UIApplication.sharedApplication().delegate as! AppDelegate
        let viewController = appDelegate.window!.rootViewController! as UIViewController
        return viewController;
    }
}
