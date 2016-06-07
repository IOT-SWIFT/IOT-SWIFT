//
//  ViewController.swift
//  IOTStarter-swift
//
//  Created by Kewalin Sakawattananon on 6/3/2559 BE.
//  Copyright © 2559 IBMSD. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func buttonClick(sender:UIButton?){
       
        let messenger: Messenger = Messenger.sharedMessenger() as! Messenger
        let serverAddress = String(format: GlobalVariable.serverAddress, GlobalVariable.organization)
        let clientID = String(format: GlobalVariable.clientID, GlobalVariable.organization, GlobalVariable.deviceType, GlobalVariable.deviceID)
        messenger.connectWithHost(serverAddress, port: GlobalVariable.port, clientId: clientID, userName: GlobalVariable.userName , password: GlobalVariable.authToken , timeout: GlobalVariable.timeout, cleanSession: GlobalVariable.cleanSession, keepAliveInterval: GlobalVariable.keepAliveInterval)


    }


}

