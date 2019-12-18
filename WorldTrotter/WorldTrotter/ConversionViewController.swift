//
//  ConversionViewController.swift
//  WorldTrotter
//
//  Created by HaroldDavidson on 12/9/19.
//  Copyright © 2019 HaroldDavidson. All rights reserved.
//

import UIKit
// see page 82 of BNR for Delegate explanation
class ConversionViewController: UIViewController, UITextFieldDelegate {
    
    
    @IBOutlet weak var celsiusLabel: UILabel!
    @IBOutlet var textField: UITextField!
    @IBOutlet weak var isReally: UILabel!
    
    
    var fahreheitValue: Measurement<UnitTemperature>? {
        didSet {
            updateCelsiusLable()
        }
    }
    var celsiusValue: Measurement<UnitTemperature>? {
        if let fahreheitValue = fahreheitValue {
            return fahreheitValue.converted(to: .celsius)
        } else {
            return nil
        }
    }
    
    let numberFormatter: NumberFormatter = {
        let nf = NumberFormatter()
        nf.numberStyle = .decimal
        nf.minimumFractionDigits = 0
        nf.maximumFractionDigits = 1
        return nf
    }()
    
    
    @IBAction func fahreheitFieldEditingChanged(_ textField: UITextField) {
        if let text = textField.text, let number = numberFormatter.number(from: text) {
            fahreheitValue = Measurement(value: number.doubleValue, unit: .fahrenheit)
        } else {
            fahreheitValue = nil
        }
        
    }
    
    @IBAction func dismissKeyboard(_ sender: UITapGestureRecognizer) {
        textField.resignFirstResponder()
    }
    
    func updateCelsiusLable() {
        if let celsiusValue = celsiusValue {
            celsiusLabel.text = numberFormatter.string(from: NSNumber(value: celsiusValue.value))
        } else {
            celsiusLabel.text = "???"
        }
    }
    
    // only allowing one decimal and numbers to be typed
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        // only allowing those characters to be typed (https://www.youtube.com/watch?v=6eBvI_08IuM)
        let allowedCharacterSet = CharacterSet(charactersIn: "0123456789.-,")
        let replacementStringCharacterSet = CharacterSet(charactersIn: string)
        if !replacementStringCharacterSet.isSubset(of: allowedCharacterSet) {
          return false
        }
        
        // only allowing one decimal and one negative to be typed
//        let existingTextHasDecimalSeparator = textField.text?.range(of: ".")
//        let replacementTextHasDecimalSeparator = string.range(of: ".")
        let currentLocale = Locale.current
        let decimalSeparator = currentLocale.decimalSeparator ?? "."
        
        let existingTextHasDecimalSeparator = textField.text?.range(of: decimalSeparator)
        let replacementTextHasDecimalSeparator = string.range(of: decimalSeparator)
        let existingTextHasDashSeparator = textField.text?.range(of: "-")
        let replacementTextHasDashSeparator = string.range(of: "-")
        if existingTextHasDecimalSeparator != nil, replacementTextHasDecimalSeparator != nil {
            return false
        } else if existingTextHasDashSeparator != nil, replacementTextHasDashSeparator != nil {
            return false
        }
        else {
            return true
        }
    }
    override func viewWillAppear(_ animated: Bool) {
        let hour = Calendar.current.component(.hour, from: Date())
        if(hour > 16) {
            view.backgroundColor = .black
            isReally.textColor = .white
            textField.backgroundColor = .lightGray
        } else {
            isReally.textColor = .black
            textField.backgroundColor = .clear
        }
    }
        
    override func viewDidLoad() {
        super.viewDidLoad()
        print("ConversionViewController loaded its view.")
        updateCelsiusLable()
    }
}
