//
//  AppDelegate.swift
//  IOTStarter-swift
//
//  Created by Kewalin Sakawattananon on 6/3/2559 BE.
//  Copyright © 2559 IBMSD. All rights reserved.
//

import UIKit
import CoreData

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    
    
    

    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        // Override point for customization after application launch.
        UILabel.appearance().font = UIFont(name: "HelveticaNeue-Light", size: 17.0)
        UIApplication.sharedApplication().idleTimerDisabled = true
        // Initialize some application settings
        return true
    }

    func applicationWillResignActive(application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
        // Saves changes in the application's managed object context before the application terminates.
        self.saveContext()
    }

    // MARK: - Core Data stack

    lazy var applicationDocumentsDirectory: NSURL = {
        // The directory the application uses to store the Core Data store file. This code uses a directory named "com.ibm.th.sd.IOTStarter_swift" in the application's documents Application Support directory.
        let urls = NSFileManager.defaultManager().URLsForDirectory(.DocumentDirectory, inDomains: .UserDomainMask)
        return urls[urls.count-1]
    }()

    lazy var managedObjectModel: NSManagedObjectModel = {
        // The managed object model for the application. This property is not optional. It is a fatal error for the application not to be able to find and load its model.
        let modelURL = NSBundle.mainBundle().URLForResource("IOTStarter_swift", withExtension: "momd")!
        return NSManagedObjectModel(contentsOfURL: modelURL)!
    }()

    lazy var persistentStoreCoordinator: NSPersistentStoreCoordinator = {
        // The persistent store coordinator for the application. This implementation creates and returns a coordinator, having added the store for the application to it. This property is optional since there are legitimate error conditions that could cause the creation of the store to fail.
        // Create the coordinator and store
        let coordinator = NSPersistentStoreCoordinator(managedObjectModel: self.managedObjectModel)
        let url = self.applicationDocumentsDirectory.URLByAppendingPathComponent("SingleViewCoreData.sqlite")
        var failureReason = "There was an error creating or loading the application's saved data."
        do {
            try coordinator.addPersistentStoreWithType(NSSQLiteStoreType, configuration: nil, URL: url, options: nil)
        } catch {
            // Report any error we got.
            var dict = [String: AnyObject]()
            dict[NSLocalizedDescriptionKey] = "Failed to initialize the application's saved data"
            dict[NSLocalizedFailureReasonErrorKey] = failureReason

            dict[NSUnderlyingErrorKey] = error as NSError
            let wrappedError = NSError(domain: "YOUR_ERROR_DOMAIN", code: 9999, userInfo: dict)
            // Replace this with code to handle the error appropriately.
            // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
            NSLog("Unresolved error \(wrappedError), \(wrappedError.userInfo)")
            abort()
        }
        
        return coordinator
    }()

    lazy var managedObjectContext: NSManagedObjectContext = {
        // Returns the managed object context for the application (which is already bound to the persistent store coordinator for the application.) This property is optional since there are legitimate error conditions that could cause the creation of the context to fail.
        let coordinator = self.persistentStoreCoordinator
        var managedObjectContext = NSManagedObjectContext(concurrencyType: .MainQueueConcurrencyType)
        managedObjectContext.persistentStoreCoordinator = coordinator
        return managedObjectContext
    }()

    // MARK: - Core Data Saving support

    func saveContext () {
        if managedObjectContext.hasChanges {
            do {
                try managedObjectContext.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nserror = error as NSError
                NSLog("Unresolved error \(nserror), \(nserror.userInfo)")
                abort()
            }
        }
    }
    
    func addLogMessage(textValue: String) {
        dispatch_async(dispatch_get_main_queue(), {() -> Void in
            GlobalVariable.messageLog.append(textValue)
            print("\(textValue)")
        })
    }
        
}

extension AppDelegate: InvocationComplete {
    func onSuccess(invocationContext: NSObject) {
        print("%@:%d - invocationContext=%@", #function, #line,invocationContext)
        if (invocationContext.isKindOfClass(MqttClient)) {
            // context is Mqtt Publish
        }
        else if (invocationContext.isKindOfClass(NSString)) {
            
            let contextString: String = String(invocationContext)
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
        print("%@:%d - invocationContext=%@", #function, #line,invocationContext)
        dispatch_async(dispatch_get_main_queue(), {() -> Void in
            let message: String = "Failed to connect to IoT. Reason Code: \(errorCode) Error Message : \(errorMessage)"
            print(message)
            self.connectMQTTServer()
        })
    }
    
    
    func handleConnectSuccess() {
        // context is Mqtt Connect
        // Enable publishing of sensor data
        print("Successfully connected to IoT Messaging Server")
        dispatch_async(dispatch_get_main_queue(), {() -> Void in
            GlobalVariable.isConnected = true
            let messenger: Messenger = Messenger.sharedMessenger() as! Messenger
            messenger.subscribe(TopicFactory.getCommandTopic("+"), qos: 2)
        })
    }
    func handleDisconnectSuccess() {
        // Context is Mqtt Disconnect
        // Disable publishing of sensor data
        print("Successfully disconnected from IoT Messaging Server")
        dispatch_async(dispatch_get_main_queue(), {() -> Void in
            GlobalVariable.isConnected = false
        })
    }
    
    func connectMQTTServer(){
        let messenger: Messenger = Messenger.sharedMessenger() as! Messenger
        let serverAddress: String = String(format: GlobalVariable.serverAddress, GlobalVariable.organization)
        let clientID: String = String(format: GlobalVariable.clientID, GlobalVariable.organization, GlobalVariable.deviceType, GlobalVariable.deviceID)
        
        messenger .connectWithHost(serverAddress, port: GlobalVariable.port, clientId: clientID, userName: GlobalVariable.userName , password: GlobalVariable.authToken , timeout: GlobalVariable.timeout, cleanSession: GlobalVariable.cleanSession, keepAliveInterval: GlobalVariable.keepAliveInterval)
    }

}

extension AppDelegate:MqttCallbacks{
    func onConnectionLost(invocationContext: NSObject, errorMessage: String) {
        print("%@:%d entered", #function, #line)
        dispatch_async(dispatch_get_main_queue(), {() -> Void in
            GlobalVariable.isConnected = false
            self.connectMQTTServer()
            GlobalVariable.isConnected = true
        })
    }
    
    func onMessageArrived(invocationContext: NSObject, message: MqttMessage) {
        print("%@:%d entered", #function, #line)
        if let payload:String =  NSString(bytes: message.payload, length: Int(message.payloadLength), encoding: NSUTF8StringEncoding) as? String  {// String(CString: UnsafePointer<CChar>(message.payload), encoding: NSASCIIStringEncoding) {
            let topic: String = message.destinationName
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
        let topicParts: [AnyObject] = topic.componentsSeparatedByString("/")
        dispatch_async(dispatch_get_main_queue(), {() -> Void in
            print("Topic : \(topic)")
            self.processTextMessage(payload)
        })
    }
    func getMessageBody(payload: String) -> NSDictionary? {
        print("\(payload)")
        do {
            let json: NSDictionary = try NSJSONSerialization.JSONObjectWithData(payload.dataUsingEncoding(NSUTF8StringEncoding)!, options: NSJSONReadingOptions.MutableContainers) as! NSDictionary
            let body: NSDictionary? = (json["d"] as! NSDictionary)
            if body != nil {
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
        var body: NSDictionary?
        body = self.getMessageBody(payload)
        if let bodyText = body {
            let textValue: String = (bodyText["text"] as! String)
            if textValue != "" {
                GlobalVariable.messageLog.append(textValue)
                print(textValue)
                
            }
        }
    }
}


