//
//  Test.swift
//  IOTStarter-swift
//
//  Created by Kewalin Sakawattananon on 6/6/2559 BE.
//  Copyright © 2559 IBMSD. All rights reserved.
//

import Foundation

class MySwiftObject : NSObject {
    
    var someProperty: AnyObject = "Some Initializer Val"
    
    override init() {}
    
    func someFunction(someArg:AnyObject) -> String {
        var returnVal = "You sent me \(someArg)"
        return returnVal
    }
    
}