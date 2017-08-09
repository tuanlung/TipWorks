//
//  ViewController.swift
//  TipWorks
//
//  Created by Tuan-Lung Wang on 8/8/17.
//  Copyright © 2017 Tuan-Lung Wang. All rights reserved.
//

import UIKit

class CalculatorViewController: UIViewController {
    
    @IBOutlet weak var numbersView: UIView!
    @IBOutlet weak var billTextField: UITextField!
    @IBOutlet weak var splitTableView: UITableView!
    @IBOutlet weak var doneButton: UIButton!
    
    var keyboardMinY: CGFloat = 0.0
    var navigationBarMaxY: CGFloat = 0.0
    var doneButtonHeight: CGFloat = 40.0
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
        // make everything hidden and change their position after view appears,
        // and then make them visible.
        hideAllObjects()

        
        
        subscribeToKeyboardEvents()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        // This has to be put in viewDidAppear to avoid a bug in textField cursor position
        // Details: https://stackoverflow.com/a/29857516
        billTextField.becomeFirstResponder()
    }
    
    func hideAllObjects() {
        numbersView.isHidden = true
        doneButton.isHidden = true
        billTextField.isHidden = true
        splitTableView.isHidden = true
    }
    
    func initializePositionOfAllViews() {
        initializeNumberViewFrame()
        initializeSplitTableViewFrame()
        initializeBillTextFieldFrame(animated: true)
        initializeDoneButtonFrame()
    }
    
    // MARK: call back functions
    func keyboardDidShow(_ notification: NSNotification) {
        
        self.keyboardMinY = view.frame.height - (notification.userInfo![UIKeyboardFrameBeginUserInfoKey] as! NSValue).cgRectValue.height
        
        // Unsubscribe once we got keyboard position
        unsubscribeToKeyboardEvents()
        
        // View Positions are depending on keyboard positons, that's why they are here
        initializePositionFactors()
        initializePositionOfAllViews()
    }
    
    // MARK: IBActions
    @IBAction func resignKeyboard(_ sender: Any) {
        view.endEditing(true)
        self.doneButton.isHidden = true
    }
    
    @IBAction func billValueChanged(_ sender: Any) {
        adjustPositionsOfViewsAfterBillValueDidChange(animated: true)
    }
}

extension CalculatorViewController {
    
    // MARK: View positions adjustment helpers
    func adjustPositionsOfViewsAfterBillValueDidChange(animated: Bool) {
        let animateDuration = 0.4
        
        if animated {
            UIView.animate(withDuration: animateDuration, animations: {
                self.numbersView.frame = CGRect(x: 0.0, y: self.navigationBarMaxY, width: self.view.frame.width, height: self.keyboardMinY - self.navigationBarMaxY - self.doneButtonHeight)
                
                self.billTextField.frame = CGRect(x: 0.0, y: 0.0, width: self.numbersView.frame.width, height: self.numbersView.frame.height)
            })
            self.doneButton.isHidden = false
        }
        
        
        
        
        
    }
    
    
    
    // MARK: View positions initializers
    func initializePositionFactors() {
        navigationBarMaxY = navigationController!.navigationBar.frame.height
    }
    
    func initializeNumberViewFrame() {
        let newHeight = keyboardMinY - navigationBarMaxY
        numbersView.frame = CGRect(x: 0.0, y: navigationBarMaxY, width: view.frame.width, height: newHeight)
        
        numbersView.isHidden = false
    }
    
    func initializeBillTextFieldFrame(animated: Bool) {

        
        if animated {
            let animateDistance: CGFloat = 40.0
            let animateDuration = 0.4
            self.billTextField.frame = CGRect(x: 0.0, y: 0.0, width: self.numbersView.frame.width - animateDistance, height: self.numbersView.frame.height)
            
            billTextField.isHidden = false
            
            UIView.animate(withDuration: animateDuration, animations: {
                self.billTextField.frame = CGRect(x: 0.0, y: 0.0, width: self.numbersView.frame.width, height: self.numbersView.frame.height)
            })
            
        } else {
            self.billTextField.frame = CGRect(x: 0.0, y: 0.0, width: self.numbersView.frame.width, height: self.numbersView.frame.height)
            billTextField.isHidden = false
        }
    }
    
    func initializeSplitTableViewFrame() {
        let newMinY = keyboardMinY - view.frame.minY
        let newHeight = view.frame.maxY - newMinY
        self.splitTableView.frame = CGRect(x: 0.0, y: newMinY, width: view.frame.width, height: newHeight)
        
        splitTableView.isHidden = false
    }

    func initializeDoneButtonFrame() {
        let buttonMinY = self.numbersView.frame.height
        
        self.doneButton.frame = CGRect(x: 0.0, y: buttonMinY, width: self.view.frame.width, height: doneButtonHeight)
    }
    
    // MARK: Keyboard events functions
    func subscribeToKeyboardEvents() {
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardDidShow(_:)), name: .UIKeyboardDidShow , object: nil)
    }
    
    func unsubscribeToKeyboardEvents() {
        NotificationCenter.default.removeObserver(self, name: .UIKeyboardDidShow, object: nil)
    }
}
