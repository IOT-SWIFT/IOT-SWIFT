//
//  Callbacks.swift
//  IOTStarter-swift
//
//  Created by Kewalin Sakawattananon on 6/5/2559 BE.
//  Copyright © 2559 IBMSD. All rights reserved.
//

import Foundation

class InvocationCallbacks:NSObject, InvocationComplete {
    func onSuccess(invocationContext: NSObject) {
        print("%s:%d - invocationContext=%@", "onSuccess", __LINE__, invocationContext)
        if (invocationContext.isKindOfClass(MqttClient)) {
            // context is Mqtt Publish
        }
        else if (invocationContext.isKindOfClass(NSString)) {
            
            var contextString: String = String(invocationContext)
            print("\(contextString)")
            if (contextString == "connect") {
                self.handleConnectSuccess()
            }
            else if (contextString == "disconnect") {
                self.handleDisconnectSuccess()
            }
            else {
                var parts: [AnyObject] = contextString.componentsSeparatedByString(":")
                if (parts[0] as! String == "subscribe") {
                    // Context is Mqtt Subscribe
                    print("Successfully subscribed to topic: %@", parts[1])
                }
                else if (parts[0] as! String == "unsubscribe") {
                    // Context is Mqtt Unsubscribe
                    print("Successfully unsubscribed from topic: %@", parts[1])

                }
            }
        }
    }
    
    func onFailure(invocationContext: NSObject!, errorCode: Int32, errorMessage: String!) {
        // NSLog("%s:%d - invocationContext=%@  errorCode=%d  errorMessage=%@", "onFailure", __LINE__, invocationContext, errorCode, errorMessage)
        print("errorCode : \(errorCode) errorMessage : \(errorMessage)")
        dispatch_async(dispatch_get_main_queue(), {() -> Void in
         var message: String = "Failed to connect to IoT. Reason Code: \(errorCode)"
         /*
         UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Connect Failed" message:message delegate:self cancelButtonTitle:nil otherButtonTitles:OK_STRING, nil];
         [alert show];*/
         })
    }
    
    
    func handleConnectSuccess() {
        // context is Mqtt Connect
        // Enable publishing of sensor data
        print("Successfully connected to IoT Messaging Server")
        dispatch_async(dispatch_get_main_queue(), {() -> Void in
            // Launch timer for publishing accelerometer data
            /*
             AppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
             appDelegate.isConnected = YES;
             [appDelegate updateViewLabelsAndButtons];
             if (appDelegate.isAccelEnabled)
             {
             [appDelegate startMotionManager];
             }
             
             if (!(appDelegate.connectionType == QUICKSTART))
             {
             Messenger *messenger = [Messenger sharedMessenger];
             [messenger subscribe:[TopicFactory getCommandTopic:@"+"] qos:0];
             }
             
             [appDelegate switchToIoTView];*/
            GlobalVariable.isConnected = true
            var messenger: Messenger = Messenger.sharedMessenger()
            messenger.subscribe(TopicFactory.getCommandTopic("+"), qos: 0)
        })
    }
    func handleDisconnectSuccess() {
        // Context is Mqtt Disconnect
        // Disable publishing of sensor data
        print("Successfully disconnected from IoT Messaging Server")
        dispatch_async(dispatch_get_main_queue(), {() -> Void in
            // Kill the timer to stop publishing accelerometer data
            /*
             AppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
             appDelegate.isConnected = NO;
             [appDelegate updateViewLabelsAndButtons];
             if (appDelegate.isAccelEnabled)
             {
             [appDelegate stopMotionManager];
             }*/
            GlobalVariable.isConnected = false
        })
    }
    
}

class GeneralCallbacks:NSObject, MqttCallbacks{
    func onConnectionLost(invocationContext: NSObject, errorMessage: String) {
        print("%s:%d entered", "onConnectionLost", __LINE__)
        dispatch_async(dispatch_get_main_queue(), {() -> Void in
            // Kill the timer to stop publishing accelerometer data
            /*
             AppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
             appDelegate.isConnected = NO;
             [appDelegate updateViewLabelsAndButtons];
             [appDelegate stopMotionManager];*/
            GlobalVariable.isConnected = false
        })
    }
    
    func onMessageArrived(invocationContext: NSObject, message: MqttMessage) {
        print("%s:%d entered", "onMessageArrived", __LINE__)
        
        if let payload:String = String(CString: UnsafePointer<CChar>(message.payload), encoding: NSASCIIStringEncoding) {
            var topic: String = message.destinationName
            self.routeMessage(topic, payload: payload)
            // Local Notifications when a message is received while app is running in background.
            dispatch_async(dispatch_get_main_queue(), {() -> Void in
            })
        }
    }
    func onMessageDelivered(invocationContext: NSObject!, messageId msgId: Int32) {
        
    }
    /** Parse the message topic and call the appropriate method based on the command type.
     *  @param topic The topic string the message was received on
     *  @param payload The message payload
     */
    
    func routeMessage(topic: String, payload: String) {
        // topicParts: @"iot-2/cmd/%@/fmt/%@"
        //   [0] = iot-2
        //   [1] = cmd
        //   [2] = <command>
        //   [3] = fmt
        //   [4] = <format>
        print("routeMessage")
        var topicParts: [AnyObject] = topic.componentsSeparatedByString("/")
        dispatch_async(dispatch_get_main_queue(), {() -> Void in
            // AppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
            // appDelegate.receiveCount++;
            //[appDelegate.iotViewController updateMessageCounts];
            if (topicParts[2] as! String == "text") {
                self.processTextMessage(payload)
            }
        })
    }
    func getMessageBody(payload: String) -> NSDictionary? {

        do {
            var json: NSDictionary = try NSJSONSerialization.JSONObjectWithData(payload.dataUsingEncoding(NSUTF8StringEncoding)!, options: NSJSONReadingOptions.MutableContainers) as! NSDictionary
            var body: NSDictionary? = (json["d"] as! NSDictionary)
            if let bodyText = body {
                return body!
                
            }else{
                print("Error in JSON: \"d\" object not found")
                
            }

        }catch{
            print("Error parsing JSON: %@", error)
        }
        return nil
    }
    
    /** Process a color command message.
     *  @param payload The message payload
     */
    /** Process a text command message.
     *  @param payload The message payload
     */
    
    func processTextMessage(payload: String) {
        // AppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
        var body: NSDictionary?
        body = self.getMessageBody(payload)
        if let bodyText = body {
            var textValue: String = (bodyText["text"] as! String)
            if textValue != "" {
                print("Received Msg")
                //[appDelegate addLogMessage:textValue];
                GlobalVariable.messageLog.append(textValue)
                print(textValue)
                
            }
        }
    }
}