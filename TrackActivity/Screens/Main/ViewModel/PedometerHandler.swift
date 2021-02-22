//
//  PedometerHandler.swift
//  TrackActivity
//
//  Created by Milton Palaguachi on 2/20/21.
//

import UIKit
import CoreMotion

class PedometerHandler {
    
    private var pedometerData = CMPedometerData()
    private var pedometer = CMPedometer()
    
    private var numberOfSteps: Int?
    private var timer = Timer()
    private var distance: Double = 0.0
    private var pace: Double = 0.0
    
    public weak var delegate: PedometorHandlerDelegate?

    //For Calculating Pace
    private var elepsedSeconds: Double = 0.0
    private var interval: Double = 0.1
    
    func startStopPedometer(_ text: String) {
        if text == PedometerStatus.start {
            self.delegate?.statusLabel(PedometerStatus.pedemeterOn)
            self.delegate?.setupPedometerStatusButton(PedometerStatus.stop,PedometerStatusColor.stopRed)
            self.pedometerStartUpdates()
            
        } else if text == PedometerStatus.stop {
            self.pedometer.stopUpdates()
            self.stopTimer()
            self.delegate?.statusLabel(PedometerStatus.pedemeterOff)
            self.delegate?.setupPedometerStatusButton(PedometerStatus.start,PedometerStatusColor.goGreen)
        }
    }
    // MARK: Private Methods
    
    //MARK: - Check If StepCounting is Available
    private func pedometerStartUpdates() {
        if CMPedometer.isStepCountingAvailable() {
            self.startTimer()
            self.pedometer.startUpdates(from: Date()) {[weak self] pedometerData, error in
                guard error == nil, let pedometerData = pedometerData, let weakSelf = self else {return print(String(describing: error))}
                weakSelf.pedometerData = pedometerData
                weakSelf.numberOfSteps = Int(truncating: pedometerData.numberOfSteps)
            }
        } else {
            print("Step Counting Not Available")
        }
    }
    
    // MARK: Display Pedometer Data
    
    func displayPedometerData() {
        self.delegate?.statusLabel( PedometerStatus.pedemeterOn + self.minutesSeconds(elepsedSeconds))
        //Steps
        guard let numberOfSteps = self.numberOfSteps else { return }
        self.delegate?.stepsLabel(String(format: "Steps: %i", numberOfSteps))
        //Distance
        guard let pedometerDistance = self.pedometerData.distance, let distance = pedometerDistance as? Double else {
            return print("Unable to to get pedometer distance")
        }
        self.distance = distance
        self.delegate?.distanceLabel(String(format: "Distance %.2f  meters", self.distance))
        //Pace
        self.updatePace()
    }
}

extension PedometerHandler: PedometorTimer {
    // MARK: Start Timer
    func startTimer() {
        print("Start Timer \(Date())")
        guard !self.timer.isValid else { return }
        //Intervar: 1 second
        self.timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true, block: { [unowned self] _ in
            self.displayPedometerData()
            self.elepsedSeconds += self.interval
        })
    }
    
    // MARK: Stop Timer
    func stopTimer() {
        print("Stop Timer \(Date())")
        self.timer.invalidate()
        self.displayPedometerData()
    }
}

extension PedometerHandler: PedometerPace {
    
    // MARK: -  Update Pace
    func updatePace() {
        if CMPedometer.isPaceAvailable() {
            guard let pedometerPace = self.pedometerData.averageActivePace, let pace = pedometerPace as? Double else {
                self.delegate?.paceLabel("Pace: N/A")
                return
            }
            self.pace = pace
            self.delegate?.paceLabel(String(format: "Avg Pace: %.2f min/mi", self.pace))
            
        } else {
            self.delegate?.paceLabel(String(format: "Avg Pace: %.2f min/mi", self.calculatedPace()))
        }
    }
    
    // MARK: -  Convert Minutes to Seconds

    func minutesSeconds(_ seconds: Double) -> String {
        let minute = Int(seconds)/60
        let secondsPart = Int(seconds) % 60
        return String(format: "%02i:%02i", minute, secondsPart)
        
    }
    
    // MARK: -  Calculate Pace

    func calculatedPace() -> Double {
        return (self.distance > 0.0) ? self.elepsedSeconds/self.distance : 0.0
    }
}
