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
        let newHeight = keyboardMinY - navigationBarMaxY
        numbersView.frame = CGRect(x: 0.0, y: navigationBarMaxY, width: view.frame.width, height: newHeight)
        print("numbersView scaled to \(numbersView.frame)")
    }

    func subscribeToKeyboardEvents() {
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardDidShow(_:)), name: .UIKeyboardDidShow , object: nil)
    }
    
    func initializePositionFactors() {
        navigationBarMaxY = view.frame.minY + navigationController!.navigationBar.frame.height
    }
    
    
    // MARK: call back functions
    func keyboardDidShow(_ notification: NSNotification) {
        
        self.keyboardMinY = view.frame.height - (notification.userInfo![UIKeyboardFrameBeginUserInfoKey] as! NSValue).cgRectValue.height
        
        initializePositionFactors()
        initializePositionOfAllViews()
        
        NotificationCenter.default.removeObserver(self, name: .UIKeyboardDidShow, object: nil)
    }
}

