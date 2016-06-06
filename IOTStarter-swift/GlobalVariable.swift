//
//  Global.swift
//  IOTStarter-swift
//
//  Created by Kewalin Sakawattananon on 6/4/2559 BE.
//  Copyright © 2559 IBMSD. All rights reserved.
//

import Foundation

struct GlobalVariable{
   // static var currentProfile:IoTProfile = IoTProfile(name: "default", organization: "0w7ce5", deviceID: "999999999", authorizationToken: "999999998")
    static var IOTServerAddress:String = "%@.messaging.internetofthings.ibmcloud.com"
    static var IOTClientID:String = "d:%@:%@:%@";
    static var IOTEventTopic:String = "iot-2/evt/%@/fmt/%@"
    static var IOTCommandTopic:String = "iot-2/cmd/%@/fmt/%@"
    static var IOTDeviceType:String = "iPhone"
    static var port:Int32 = 1883
    static var organization:String = "0w7ce5"
    static var deviceID:String = "999999999"
    static var userName:String = "use-token-auth"
    static var authToken:String = "999999998"
    static var timeout:Int32 = 10
    static var cleanSession:Bool = false
    static var keepAliveInterval:Int32 = 30
    
    static var messageLog = [String]()
    
    //static var connectionType:CONNECTION_TYPE = CONNECTION_TYPE.IOTF
    static var isConnected:Bool = false
}
