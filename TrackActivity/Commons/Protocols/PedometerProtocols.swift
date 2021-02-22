//
//  PedometerProtocols.swift
//  TrackActivity
//
//  Created by Milton Palaguachi on 2/21/21.
//

import UIKit

protocol PedometorTimer {
    func startTimer()
    func stopTimer()
}
protocol PedometerPace {
    func updatePace()
    func calculatedPace() -> Double
    func minutesSeconds(_ seconds: Double) -> String
}

protocol PedometorHandlerDelegate: AnyObject {
    func paceLabel(_ text: String)
    func stepsLabel(_ text: String)
    func distanceLabel(_ text: String)
    func statusLabel(_ text: String)
    func setupPedometerStatusButton(_ text: String, _ background: UIColor)
}
