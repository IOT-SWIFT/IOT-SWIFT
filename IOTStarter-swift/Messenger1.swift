//
//  Messenger.swift
//  IOTStarter-swift
//
//  Created by Kewalin Sakawattananon on 6/5/2559 BE.
//  Copyright © 2559 IBMSD. All rights reserved.
//

import Foundation

class  Messenger: NSObject {
    
    var client:MqttClient?
    var tracer:Trace?
    override init() {
        super.init()
        self.client = MqttClient()
        self.client!.callbacks = GeneralCallbacks()
        self.tracer = Trace(traceLevel:  TraceLevel.Log)
    }
    /** Return the singleton instance of the Messenger object.
     */
    
    class func sharedMessenger() -> Messenger {
        var shared: Messenger? = nil
        var onceToken:  dispatch_once_t = 0
        dispatch_once(&onceToken, {() -> Void in
            shared = Messenger.init()
        })
        return shared!
    }
    /** Return true if the client is currently connected.
     *  Return false otherwise.
     */
    
    func isMqttConnected() -> Bool {
        var connected: Bool = false
        if let client1 = self.client  {
            if GlobalVariable.isConnected {
                connected = true
            }
        }
        return connected
    }
    
    /** Create the connection to the MQTT server.
     *  @param host The host of the server to connect to.
     *  @param port The port of the server to connect to.
     *  @param clientId The MQTT client ID to connect with.
     */
    
    func connectWithHost(host: String, port: Int32, clientId: String) {
        print("%s:%d entered", "connectWithHost", __LINE__)
        if !self.isMqttConnected() {
            //AppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
            var opts: ConnectOptions = ConnectOptions()
            opts.timeout = 5
            opts.cleanSession = false
            opts.keepAliveInterval = 30
            opts.userName = "use-token-auth"
            opts.password = "999999998"
            MqttClient.setTrace(self.tracer)
            NSLog("Connecting to IoT Messaging Server\n\thost: %@\n\tport: %d\n\tclientid: %@\n\tusername: %@\n\tpassword: %@", host, port, clientId, opts.userName, opts.password)
            self.client = MqttClient(host: host, port: port, clientId: clientId)
            self.client!.connectWithOptions(opts, invocationContext: "connect", onCompletion: InvocationCallbacks())
        }
    }
    /** Subscribe to topic filter topicFilter at quality of service qos.
     *  @param topicFilter The MQTT topic filter to subscribe to
     *  @param qos The quality of service to subscribe with.
     */
    
    func subscribe(topicFilter: String, qos: Int32) {
        print("%s:%d entered", "subscribe", __LINE__)
        if self.isMqttConnected() {
            print(topicFilter)
            var context: String = "subscribe:".stringByAppendingString(topicFilter)
            self.client!.subscribe(topicFilter, qos: qos, invocationContext: context, onCompletion: InvocationCallbacks())
        }
    }
    /** Unsubscribe from topic filter topicFilter.
     *  @param topicFilter The MQTT topic filter to unsubscribe from
     */
    
    func unsubscribe(topicFilter: String) {
        NSLog("%s:%d entered", "unsubscribe", __LINE__)
        if self.isMqttConnected() {
            var context: String = "unsubscribe:".stringByAppendingString(topicFilter)
            self.client!.unsubscribe(topicFilter, invocationContext: context, onCompletion: InvocationCallbacks())
        }
    }
    
    /** Disconnect from the MQTT server.
     */
    
    func disconnect() {
        NSLog("%s:%d entered", "disconnect", __LINE__)
        if self.isMqttConnected() {
            self.client!.disconnectWithOptions(nil, invocationContext: "disconnect", onCompletion: InvocationCallbacks())
        }
    }
    
}