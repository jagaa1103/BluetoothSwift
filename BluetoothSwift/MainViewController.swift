//
//  ViewController.swift
//  BluetoothSwift
//
//  Created by Enkhjargal Gansukh on 5/22/15.
//  Copyright (c) 2015 Enkhjargal Gansukh. All rights reserved.
//

import UIKit

class MainViewController: UIViewController {

    @IBOutlet weak var distanceTextField: UITextField!
    @IBOutlet weak var unitSegment: UISegmentedControl!
    @IBOutlet weak var holeTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        VoiceService.sharedInstance.setDeviceLanguage()
        CentralService.sharedInstance.startService()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidAppear(animated: Bool) {
        CentralService.sharedInstance.setView(self)
        CentralService.sharedInstance.scanPeripheral()
    }

    func endGame(){
        
        // Create the alert controller
        var alertController = UIAlertController(title: "Alert", message: "Your current Game is ended. If you want to start again please click Start Game button!", preferredStyle: .Alert)
        
        // Create the actions
        var okAction = UIAlertAction(title: "End", style: UIAlertActionStyle.Default) {
            UIAlertAction in
            self.holeTextField.text = ""
            self.distanceTextField.text = ""
            exit(0)
        }
        var cancelAction = UIAlertAction(title: "Cancel", style: UIAlertActionStyle.Cancel) {
            UIAlertAction in
            println("Cancel Pressed")
        }
        
        // Add the actions
        alertController.addAction(okAction)
        alertController.addAction(cancelAction)
        
        // Present the controller
        self.presentViewController(alertController, animated: true, completion: nil)
    }


}

