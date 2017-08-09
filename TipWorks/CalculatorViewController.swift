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
    @IBOutlet weak var tipPercView: UIView!
    @IBOutlet weak var doneButton: UIButton!
    @IBOutlet weak var tipPercSegControl: UISegmentedControl!
    @IBOutlet weak var tipView: UIView!
    @IBOutlet weak var tipTitleLabel: UILabel!
    @IBOutlet weak var tipValueLabel: UILabel!
    @IBOutlet weak var totalView: UIView!
    @IBOutlet weak var totalTitleLabel: UILabel!
    @IBOutlet weak var totalValueLabel: UILabel!
    
    var keyboardMinY: CGFloat = 0.0
    var navigationBarMaxY: CGFloat = 0.0
    var tipPercViewHeight: CGFloat = 40.0
    var doneButtonWidth: CGFloat = 60.0
    var billTextFieldHeightRaito: CGFloat = 0.5
    var tipViewHeightRatio: CGFloat = 0.25
    var totalViewHeightRatio: CGFloat = 0.25
    
    
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
        tipPercSegControl.isHidden = true
        tipPercView.isHidden = true
        tipView.isHidden = true
        totalView.isHidden = true
    }
    
    func initializePositionOfAllViews() {
        initializeSplitTableViewFrame()
        initializeTipPercViewFrame()
        initializeNumberViewFrame()
    }
    
    // MARK: call back functions
    func keyboardDidShow(_ notification: NSNotification) {
        
        keyboardMinY = view.frame.height - (notification.userInfo![UIKeyboardFrameBeginUserInfoKey] as! NSValue).cgRectValue.height
        
        // Unsubscribe once we got keyboard position
        unsubscribeToKeyboardEvents()
        
        // View Positions are depending on keyboard positons, that's why they are here
        initializePositionFactors()
        initializePositionOfAllViews()
    }
    
    // MARK: IBActions
    @IBAction func resignKeyboard(_ sender: Any) {
        view.endEditing(true)
        moveTipPercSegControl(direction: .Right, animated: true)
        doneButton.isHidden = true
    }
    
    @IBAction func billValueChanged(_ sender: Any) {
        adjustPositionsOfViewsAfterBillValueDidChange(animated: true)
    }
    
    
    @IBAction func billTextFieldEditDidBegin(_ sender: Any) {
        if billHasValue() {
            adjustPositionsOfViewsAfterBillValueDidChange(animated: true)
        }
    }
}

extension CalculatorViewController {
    
    // MARK: View positions adjustment helpers
    func adjustPositionsOfViewsAfterBillValueDidChange(animated: Bool) {

        moveTipPercSegControl(direction: .Left, animated: true)
        doneButton.isHidden = false
        expandTotalViewFrame(animated: true)

    }
    
    func expandTotalViewFrame(animated: Bool) {
        let height = numbersView.frame.height * totalViewHeightRatio
        let animateDuration = 0.4
        
        if animated {
            
            self.totalView.isHidden = false
            
            UIView.animate(withDuration: animateDuration, animations: {
                self.totalView.frame = CGRect(x: 0.0, y: self.numbersView.frame.height - height, width: self.numbersView.frame.width, height: height)
                self.billTextField.frame = CGRect(x: 0.0, y: 0.0, width: self.billTextField.frame.width, height: self.numbersView.frame.height - height)
            });
            
        } else {
            totalView.frame = CGRect(x: 0.0, y: numbersView.frame.height - height, width: numbersView.frame.width, height: height)
            billTextField.frame = CGRect(x: 0.0, y: 0.0, width: billTextField.frame.width, height: numbersView.frame.height - height)
            
            totalView.isHidden = false
        }
    }
    
    
    
    func moveTipPercSegControl(direction: Direction, animated: Bool) {
        let animateDuration = 0.4
        let spaceOnLeft = (direction == .Left) ? self.doneButton.frame.width : 0.0
        
        if animated {
            UIView.animate(withDuration: animateDuration, animations: {
                self.tipPercSegControl.frame = CGRect(x: 0.0, y: 0.0, width: self.tipPercView.frame.width - spaceOnLeft, height: self.tipPercView.frame.height)
            })
            
        } else {
            tipPercSegControl.frame = CGRect(x: 0.0, y: 0.0, width: tipPercView.frame.width - spaceOnLeft, height: tipPercView.frame.height)
        }
    }
    
    
    
    // MARK: View positions initializers
    func initializePositionFactors() {
        navigationBarMaxY = navigationController!.navigationBar.frame.height
    }
    
    func initializeSplitTableViewFrame() {
        let newMinY = keyboardMinY - view.frame.minY
        let newHeight = view.frame.maxY - newMinY
        splitTableView.frame = CGRect(x: 0.0, y: newMinY, width: view.frame.width, height: newHeight)
        
        splitTableView.isHidden = false
    }
    
    func initializeTipPercViewFrame() {
        tipPercView.frame = CGRect(x: 0.0, y: keyboardMinY - tipPercViewHeight, width: view.frame.width, height: tipPercViewHeight)
        
        initializeDoneButtonFrame()
        initializeTipPercSegControlFrame()
        
        tipPercView.isHidden = false
    }
    
    func initializeNumberViewFrame() {
        let newHeight = tipPercView.frame.minY - navigationBarMaxY
        
        numbersView.frame = CGRect(x: 0.0, y: navigationBarMaxY, width: view.frame.width, height: newHeight)
        
        initializeTotalViewFrame()
        initializeBillTextFieldFrame(animated: true)
        
        numbersView.isHidden = false
    }
    
    func initializeTotalViewFrame() {
        totalView.frame = CGRect(x: 0.0, y: numbersView.frame.maxY, width: numbersView.frame.width, height: 0.0)
    }
    
    func initializeTipViewFrame() {
        
    }
    
    
    
    func initializeDoneButtonFrame() {
        
        doneButton.frame = CGRect(x: tipPercView.frame.width - doneButtonWidth, y: 0.0, width: doneButtonWidth, height: tipPercView.frame.height)
    }
    
    func initializeTipPercSegControlFrame() {
        tipPercSegControl.frame = CGRect(x: 0.0, y: 0.0, width: tipPercView.frame.width, height: tipPercView.frame.height)
        tipPercSegControl.isHidden = false
    }
    
    

    
    func initializeBillTextFieldFrame(animated: Bool) {

        
        if animated {
            let animateDistance: CGFloat = 40.0
            let animateDuration = 0.4
            billTextField.frame = CGRect(x: 0.0, y: 0.0, width: numbersView.frame.width - animateDistance, height: numbersView.frame.height)
            
            billTextField.isHidden = false
            
            UIView.animate(withDuration: animateDuration, animations: {
                self.billTextField.frame = CGRect(x: 0.0, y: 0.0, width: self.numbersView.frame.width, height: self.numbersView.frame.height)
            })
            
        } else {
            billTextField.frame = CGRect(x: 0.0, y: 0.0, width: numbersView.frame.width, height: numbersView.frame.height)
            billTextField.isHidden = false
        }
    }
    

    // MARK: Bill Text Value
    func billHasValue() -> Bool {
        if let text = billTextField.text {
            return text != "$"
        } else {
            return false
        }
    }

    
    // MARK: Keyboard events functions
    func subscribeToKeyboardEvents() {
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardDidShow(_:)), name: .UIKeyboardDidShow , object: nil)
    }
    
    func unsubscribeToKeyboardEvents() {
        NotificationCenter.default.removeObserver(self, name: .UIKeyboardDidShow, object: nil)
    }
}

enum Direction {
    case Left, Right
}
