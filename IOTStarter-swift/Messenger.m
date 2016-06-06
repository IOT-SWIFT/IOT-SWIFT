/*
 Licensed Materials - Property of IBM
 
 © Copyright IBM Corporation 2014,2015. All Rights Reserved.
 
 This licensed material is sample code intended to aid the licensee in the development of software for the Apple iOS and OS X platforms . This sample code is  provided only for education purposes and any use of this sample code to develop software requires the licensee obtain and comply with the license terms for the appropriate Apple SDK (Developer or Enterprise edition).  Subject to the previous conditions, the licensee may use, copy, and modify the sample code in any form without payment to IBM for the purposes of developing software for the Apple iOS and OS X platforms.
 
 Notwithstanding anything to the contrary, IBM PROVIDES THE SAMPLE SOURCE CODE ON AN "AS IS" BASIS AND IBM DISCLAIMS ALL WARRANTIES, EXPRESS OR IMPLIED, INCLUDING, BUT NOT LIMITED TO, ANY IMPLIED WARRANTIES OR CONDITIONS OF MERCHANTABILITY, SATISFACTORY QUALITY, FITNESS FOR A PARTICULAR PURPOSE, TITLE, AND ANY WARRANTY OR CONDITION OF NON-INFRINGEMENT. IBM SHALL NOT BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY OR ECONOMIC CONSEQUENTIAL DAMAGES ARISING OUT OF THE USE OR OPERATION OF THE SAMPLE SOURCE CODE. IBM SHALL NOT BE LIABLE FOR LOSS OF, OR DAMAGE TO, DATA, OR FOR LOST PROFITS, BUSINESS REVENUE, GOODWILL, OR ANTICIPATED SAVINGS. IBM HAS NO OBLIGATION TO PROVIDE MAINTENANCE, SUPPORT, UPDATES, ENHANCEMENTS OR MODIFICATIONS TO THE SAMPLE SOURCE CODE.
 */

//
//  Messenger.m
//  IoTstarter
//
#import "Messenger.h"
#import "UIKit/UIKit.h"

@implementation Messenger

- (id)init
{
    if (self = [super init])
    {
        self.client = [MqttClient alloc];
        self.client.callbacks = [[UIApplication sharedApplication] delegate];
        self.tracer = [[Trace alloc] initWithTraceLevel:2];
    }
    return self;
}

/** Return the singleton instance of the Messenger object.
 */
+ (id)sharedMessenger
{
    static Messenger *shared = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        shared = [[self alloc] init];
    });
    return shared;
}

#pragma mark Instance Methods

/** Return true if the client is currently connected.
 *  Return false otherwise.
 */
- (BOOL)isMqttConnected
{
    BOOL connected = NO;
    if (self.client != nil && self.client.isConnected)
    {
        connected = YES;
    }
    return connected;
}

/** Create the connection to the MQTT server.
 *  @param host The host of the server to connect to.
 *  @param port The port of the server to connect to.
 *  @param clientId The MQTT client ID to connect with.
 */
- (void)connectWithHost:(NSString *)host
                   port:(int)port
               clientId:(NSString *)clientId
               userName:(NSString *)userName
               password:(NSString *)password
                timeout:(int)timeout
           cleanSession:(BOOL)cleanSession
      keepAliveInterval:(int)keepAliveInterval
{
    NSLog(@"%s:%d entered", __func__, __LINE__);
    if (![self isMqttConnected])
    {
        //AppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
        ConnectOptions *opts = [[ConnectOptions alloc] init];
        opts.timeout = timeout;
        opts.cleanSession = cleanSession;
        opts.keepAliveInterval = keepAliveInterval;
        opts.userName = userName;
        opts.password = password;
        
        [MqttClient setTrace:self.tracer];
        
        NSLog(@"Connecting to IoT Messaging Server\n\thost: %@\n\tport: %d\n\tclientid: %@\n\tusername: %@\n\tpassword: ********", host, port, clientId, opts.userName);
        self.client = [self.client initWithHost:host port:port clientId:clientId];
        
        [self.client connectWithOptions:opts invocationContext:@"connect" onCompletion:[[UIApplication sharedApplication] delegate]];
    }
}


/** Subscribe to topic filter topicFilter at quality of service qos.
 *  @param topicFilter The MQTT topic filter to subscribe to
 *  @param qos The quality of service to subscribe with.
 */
- (void)subscribe:(NSString *)topicFilter
              qos:(int)qos
{
    NSLog(@"%s:%d entered", __func__, __LINE__);
    if ([self isMqttConnected])
    {
        NSString *context = [@"subscribe:" stringByAppendingString:topicFilter];
        [self.client subscribe:topicFilter qos:qos invocationContext:context onCompletion:[[UIApplication sharedApplication] delegate]];
    }
}

/** Unsubscribe from topic filter topicFilter.
 *  @param topicFilter The MQTT topic filter to unsubscribe from
 */
- (void)unsubscribe:(NSString *)topicFilter
{
    NSLog(@"%s:%d entered", __func__, __LINE__);
    if ([self isMqttConnected])
    {
        NSString *context = [@"unsubscribe:" stringByAppendingString:topicFilter];
        [self.client unsubscribe:topicFilter invocationContext:context onCompletion:[[UIApplication sharedApplication] delegate]];
    }
}

/** Disconnect from the MQTT server.
 */
- (void)disconnect
{
    NSLog(@"%s:%d entered", __func__, __LINE__);
    if ([self isMqttConnected])
    {
        [self.client disconnectWithOptions:nil invocationContext:@"disconnect" onCompletion:[[UIApplication sharedApplication] delegate]];
    }
}

@end
