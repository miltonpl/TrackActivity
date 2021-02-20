//
//  Constants.swift
//  CoreMotionPedometer
//
//  Created by Milton Palaguachi on 2/11/21.
//

import UIKit

enum PedometerStatus {
    static let pedemeterOn = "Pedometer On"
    static let pedemeterOff = "Pedometer Off"
    static let start = "Start"
    static let stop = "Stop"
}

enum PedometerStatusColor {
    static let stopRed = UIColor(displayP3Red: 1.0, green: 0.0, blue: 0.15, alpha: 1.0)
    static let goGreen = UIColor(displayP3Red: 0.0, green: 1.0, blue: 0.15, alpha: 1.0)
}
