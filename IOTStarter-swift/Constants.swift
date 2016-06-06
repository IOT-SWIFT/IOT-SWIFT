//
//  Constants.swift
//  IOTStarter-swift
//
//  Created by Kewalin Sakawattananon on 6/5/2559 BE.
//  Copyright © 2559 IBMSD. All rights reserved.
//

import Foundation
/*
enum views : Int {
    case LOGIN
    case IOT
    case INPUT
    case SETTINGS
    case LOG
    case PROFILES
}*/
enum CONNECTION_TYPE : Int {
    case QUICKSTART
    case IOTF
    case M2M
}

/** File name for storing application properties on device */
let IOTArchiveFileName: String = "/IoTstarter.archive"
/** Application property names */
let IOTAuthToken: String = "authtoken"
let IOTDeviceID: String = "deviceid"
let IOTOrganization: String = "organization"
// IoT API Constants
let IOTDeviceType: String = "iPhone"
// MQTT Constants
let IOTServerAddress: String = "%@.messaging.internetofthings.ibmcloud.com"
let IOTServerPort: Int32 = 1883
// d:org:type:id
let IOTClientID: String = "d:%@:%@:%@"
let IOTEventTopic: String = "iot-2/evt/%@/fmt/%@"
let IOTCommandTopic: String = "iot-2/cmd/%@/fmt/%@"
// The output below is limited by 1 KB.
// Please Sign Up (Free!) to remove this limitation.

// M2M Demos MQTT Properties
let IOTM2MOrgID: String = "m2m"
let IOTM2MDemosServer: String = "messagesight.demos.ibm.com"
let IOTM2MClientID: String = "d:m2m:%@"
let IOTM2MEventTopic: String = "iotstarter/%@/%@"
// IoT QuickStart MQTT Properties
let IOTQuickStartOrgID: String = "quickstart"
let IOTQuickStartServer: String = "184.172.124.189"
// IoT Events and Commands
let IOTAccelEvent: String = "accel"
let IOTColorEvent: String = "color"
let IOTTouchMoveEvent: String = "touchmove"
let IOTSwipeEvent: String = "swipe"
let IOTLightEvent: String = "light"
let IOTTextEvent: String = "text"
let IOTAlertEvent: String = "alert"
let IOTDirectionEvent: String = "direction"
let IOTGamepadEvent: String = "gamepad"
let IOTStatusEvent: String = "status"
// Login View button and placeholder text
let IOTOrgPlaceholder: String = "Organization ID"
let IOTDevicePlaceholder: String = "Device ID"
let IOTAuthPlaceholder: String = "Authorization Token"
let IOTShowTokenLabel: String = "Show Auth Token"
let IOTHideTokenLabel: String = "Hide Auth Token"
let IOTActivateLabel: String = "Activate Sensor"
let IOTDeactivateLabel: String = "Deactivate Sensor"
let IOTSensorFreqDefault: Double = 1.0
let IOTSensorFreqFast: Double = 0.2

// Extra strings
let YES_STRING: String = "Yes"
let NO_STRING: String = "No"
let CANCEL_STRING: String = "Cancel"
let SUBMIT_STRING: String = "Submit"
let OK_STRING: String = "OK"
// JSON Fields
let JSON_SCREEN_X: String = "screenX"
let JSON_SCREEN_Y: String = "screenY"
let JSON_DELTA_X: String = "deltaX"
let JSON_DELTA_Y: String = "deltaY"
let JSON_ENDED: String = "ended"
let JSON_TEXT: String = "text"
let JSON_COLOR_R: String = "r"
let JSON_COLOR_G: String = "g"
let JSON_COLOR_B: String = "b"
let JSON_ALPHA: String = "alpha"
let JSON_ROLL: String = "roll"
let JSON_PITCH: String = "pitch"
let JSON_YAW: String = "yaw"
let JSON_ACCEL_X: String = "acceleration_x"
let JSON_ACCEL_Y: String = "acceleration_y"
let JSON_ACCEL_Z: String = "acceleration_z"
let JSON_LAT: String = "lat"
let JSON_LON: String = "lon"
let JSON_BUTTON: String = "button"
let JSON_DPAD_X: String = "x"
let JSON_DPAD_Y: String = "y"
let JSON_DIRECTION_UP: String = "UP"
let JSON_DIRECTION_DOWN: String = "DOWN"
let JSON_DIRECTION_LEFT: String = "LEFT"
let JSON_DIRECTION_RIGHT: String = "RIGHT"
let JSON_BUTTON_A: String = "A"
let JSON_BUTTON_B: String = "B"
let JSON_BUTTON_X: String = "X"
let JSON_BUTTON_Y: String = "Y"



