//
//  ViewController.swift
//  TipWorks
//
//  Created by Tuan-Lung Wang on 8/8/17.
//  Copyright © 2017 Tuan-Lung Wang. All rights reserved.
//

import UIKit

class CalculatorViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate {
    
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
    var maxNumOfSplit = 10
    var tipPercOptionsMapping = [0.18, 0.20, 0.25]
    
    
    // MARK: Life cycle
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
    
    
    // MARK: table view delegate functions
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return maxNumOfSplit - 1
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        return
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "splitTableViewCell")!
        
        let numToSplit = indexPath.row + 2
        let title = "Party of \(numToSplit), each pays about: "
        
        let totalStr: String = totalValueLabel.text!.replacingOccurrences(of: "$", with: "")
        let total = Double(totalStr)!
        let share = String.init(format: "$%.2f", total/Double(numToSplit))
        
        cell.textLabel!.text = title
        cell.detailTextLabel!.text = share
        return cell
    }
    
    // MARK: textField delegate functions
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        textField.text = "$"
        updateNumbers()
        return true
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        if string == "0" && textField.text == "$0" {
            return false
        }
        
        if string == "." && textField.text!.contains(".") {
            return false
        }
        
        if string == "" && textField.text == "$" {
            return false
        }

        // Nothing is less than a penny, we only take at most two digits after decimal point
        if string != "" && digitsAfterDecimalPoint(textField.text!) >= 2 {
            return false
        }
        
        var numberStr = (textField.text! as NSString).replacingCharacters(in: range, with: string)
        
        if numberStr == "$" {
            numberStr = "0"
        } else {
            numberStr = numberStr.replacingOccurrences(of: "$", with: "")
        }
        
        updateNumbers(numberStr)
        
        if textField.text == "$0" {
            textField.text = ("$" + numberStr).replacingOccurrences(of: "$0", with: "$")
            return false
        }
        
        return true
    }
    
    func updateNumbers() {
        let billNumberStr = billTextField.text!.replacingOccurrences(of: "$", with: "")
        updateNumbers(billNumberStr)
    }
    
    func updateNumbers(_ billNumberStr: String) {
        let bill = Double(billNumberStr)
        let tipPerc = tipPercOptionsMapping[tipPercSegControl.selectedSegmentIndex]

        if let bill = bill {
            let tipInPenny: Double = round(bill * tipPerc * 100.0)
            let tip: Double = tipInPenny / 100.0
            let total: Double = bill + tip
        
            tipValueLabel.text = "$" + String.init(format: "%.2f", tip)
            totalValueLabel.text = "$" + String.init(format: "%.2f", total)
        } else {
            tipValueLabel.text = "$0.00"
            totalValueLabel.text = "$0.00"
        }
        
        splitTableView.reloadData()
    }
    
    
    func digitsAfterDecimalPoint(_ numberStr: String) -> Int {
        var numOfDigits = 0
        var foundDecimalPoint = false
        for c in numberStr.characters {
            if foundDecimalPoint {
                numOfDigits = numOfDigits + 1
            } else if c == "." {
                foundDecimalPoint = true
            }
        }
        return numOfDigits
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
    
    
    @IBAction func tipPercSegControlValueDidChange(_ sender: Any) {
        updateNumbers()
    }
}

extension CalculatorViewController {
    
    // MARK: View positions adjustment helpers
    func adjustPositionsOfViewsAfterBillValueDidChange(animated: Bool) {

        moveTipPercSegControl(direction: .Left, animated: true)
        doneButton.isHidden = false
        expandTotalViewFrame(animated: true)
        expandTipViewFrame(animated: true)
    }
    
    func expandTotalViewFrame(animated: Bool) {
        let height = numbersView.frame.height * totalViewHeightRatio
        let animateDuration = 0.4
        
        let spaceToLeft: CGFloat = 20.0
        let spaceToRight: CGFloat = 0.0
        let spaceInBetween: CGFloat = 10.0
        
        if animated {
            
            totalView.isHidden = false
            
            UIView.animate(withDuration: animateDuration, animations: {
                self.totalView.frame = CGRect(x: 0.0, y: self.numbersView.frame.height - height, width: self.numbersView.frame.width, height: height)
                self.billTextField.frame = CGRect(x: 0.0, y: 0.0, width: self.billTextField.frame.width, height: self.numbersView.frame.height - height)
            });
            
        } else {
            totalView.frame = CGRect(x: 0.0, y: numbersView.frame.height - height, width: numbersView.frame.width, height: height)
            billTextField.frame = CGRect(x: 0.0, y: 0.0, width: billTextField.frame.width, height: numbersView.frame.height - height)
            
            totalView.isHidden = false
        }
        
        totalTitleLabel.frame = CGRect(x: spaceToLeft, y: 0.0, width: totalTitleLabel.frame.width, height: totalView.frame.height)
        totalValueLabel.frame = CGRect(x: totalTitleLabel.frame.maxX + spaceInBetween, y: 0.0, width: totalView.frame.width - spaceToRight - totalTitleLabel.frame.maxX - spaceInBetween, height: totalView.frame.height)
    }
    
    func expandTipViewFrame(animated: Bool) {
        let height = numbersView.frame.height * tipViewHeightRatio
        let billTextFieldMaxY = numbersView.frame.height - totalView.frame.height - height
        
        let animateDuration = 0.4
        
        let spaceToLeft: CGFloat = 20.0
        let spaceToRight: CGFloat = 0.0
        let spaceInBetween: CGFloat = 10.0
        
        if animated {
            
            tipView.isHidden = false
            
            UIView.animate(withDuration: animateDuration, animations: {
                self.tipView.frame = CGRect(x: 0.0, y: billTextFieldMaxY, width: self.numbersView.frame.width, height: height)
                self.billTextField.frame = CGRect(x: 0.0, y: 0.0, width: self.billTextField.frame.width, height: billTextFieldMaxY)
            });
            
        } else {
            tipView.frame = CGRect(x: 0.0, y: billTextFieldMaxY, width: numbersView.frame.width, height: height)
            billTextField.frame = CGRect(x: 0.0, y: 0.0, width: billTextField.frame.width, height: billTextFieldMaxY)
            
            tipView.isHidden = false
        }
        
        tipTitleLabel.frame = CGRect(x: spaceToLeft, y: 0.0, width: totalTitleLabel.frame.width, height: tipView.frame.height)
        tipValueLabel.frame = CGRect(x: tipTitleLabel.frame.maxX + spaceInBetween, y: 0.0, width: tipView.frame.width - spaceToRight - tipTitleLabel.frame.maxX - spaceInBetween, height: tipView.frame.height)
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
        initializeTipViewFrame()
        initializeBillTextFieldFrame(animated: true)
        
        numbersView.isHidden = false
    }
    
    func initializeTotalViewFrame() {
        totalView.frame = CGRect(x: 0.0, y: numbersView.frame.maxY, width: numbersView.frame.width, height: 0.0)
    }
    
    func initializeTipViewFrame() {
        tipView.frame = CGRect(x: 0.0, y: numbersView.frame.maxY, width: numbersView.frame.width, height: 0.0)
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
