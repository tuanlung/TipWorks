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

    var keyboardMinY: CGFloat = 0.0
    var navigationBarMaxY: CGFloat = 0.0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        subscribeToKeyboardEvents()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        billTextField.becomeFirstResponder()        
    }
    
    
    func initializePositionOfAllViews() {
        initializeNumberViewFrame()
        //initializeBillTextField()
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
}

extension CalculatorViewController {
    
    // View positions helpers
    func initializePositionFactors() {
        navigationBarMaxY = view.frame.minY + navigationController!.navigationBar.frame.height
    }
    
    func initializeNumberViewFrame() {
        let newHeight = keyboardMinY - navigationBarMaxY
        numbersView.frame = CGRect(x: 0.0, y: navigationBarMaxY, width: view.frame.width, height: newHeight)
    }
    
    // MARK: Keyboard events functions
    func subscribeToKeyboardEvents() {
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardDidShow(_:)), name: .UIKeyboardDidShow , object: nil)
    }
    
    func unsubscribeToKeyboardEvents() {
        NotificationCenter.default.removeObserver(self, name: .UIKeyboardDidShow, object: nil)
    }
}
