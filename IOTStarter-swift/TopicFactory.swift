//
//  TopicFactory.swift
//  IOTStarter-swift
//
//  Created by Kewalin Sakawattananon on 6/6/2559 BE.
//  Copyright © 2559 IBMSD. All rights reserved.
//

import Foundation

class TopicFactory {
    class func getEventTopic(event: String) -> String {
        var topicString: String = String(format: GlobalVariable.eventTopic, event, "json")
        return topicString
    }
    /** Retrieve the command topic string for a specific command type.
     *  @param command The command type to get the topic string for
     *  @return topicString The command topic string for command
     */
    
    class func getCommandTopic(command: String) -> String {
        var topicString: String = String(format: GlobalVariable.commandTopic, command, "json")
        return topicString
    }
}