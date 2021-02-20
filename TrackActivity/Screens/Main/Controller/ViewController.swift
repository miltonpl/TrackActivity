//
//  ViewController.swift
//  CoreMotionPedometer
//
//  Created by Milton Palaguachi on 2/11/21.
//

import UIKit
import CoreMotion

class ViewController: UIViewController {
    
    @IBOutlet weak var statusLabel: UILabel!
    @IBOutlet weak var stepsLabel: UILabel!
    @IBOutlet weak var distanceLabel: UILabel!
    @IBOutlet weak var paceLabel: UILabel!
    @IBOutlet weak var startStopRedometer: UIButton!
    
    private var pedometerData = CMPedometerData()
    private var pedometer = CMPedometer()
    
    private var numberOfSteps: Int?
    private var timer = Timer()
    private var distance: Double = 0.0
    private var pace: Double = 0.0
    
    //For Calculating Pace
    private var elepsedSeconds: Double = 0.0
    private var interval: Double = 0.1
    
   // MARK: - View Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    // MARK: - IBAction StartStopPedometer
    @IBAction func startStopPedometer(_ sender: UIButton) {
        if sender.titleLabel?.text == PedometerStatus.start {
            self.statusLabel.text = PedometerStatus.pedemeterOn
            sender.setTitle(PedometerStatus.stop, for: .normal)
            sender.backgroundColor = PedometerStatusColor.stopRed
            self.stepCountingIfAvailabel()
            
        } else {
            self.pedometer.stopUpdates()
            self.stopTimer()
            statusLabel.text = PedometerStatus.pedemeterOff
            sender.backgroundColor = PedometerStatusColor.goGreen
            sender.setTitle(PedometerStatus.start, for: .normal)
        }
    }
    
    // MARK: Private Methods
    
    //MARK: - Check If SteipCounting is Available
    private func stepCountingIfAvailabel() {
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
    
    // MARK: Start Timer
    private func startTimer() {
//        print("Start Timer \(Date())")
        guard !self.timer.isValid else { return }
        //Intervar: 1 second
        self.timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true, block: { [unowned self] _ in
            self.displayPedometerData()
            self.elepsedSeconds += self.interval
        })
    }
    
    // MARK: Stop Timer
    private func stopTimer() {
//        print("Stop Timer \(Date())")
        self.timer.invalidate()
        self.displayPedometerData()
    }
    
    // MARK: Display Pedometer Data
    
    func displayPedometerData() {
        self.statusLabel.text = PedometerStatus.pedemeterOn + self.minutesSeconds(elepsedSeconds)
        //Steps
        guard let numberOfSteps = self.numberOfSteps else { return }
        self.stepsLabel.text = String(format: "Steps: %i", numberOfSteps)
        print("\(Date()) --- \(self.stepsLabel.text ?? "")")
        //Distance
        guard let pedometerDistance = self.pedometerData.distance, let distance = pedometerDistance as? Double else {
            return print("Unable to to get pedometer distance")
        }
        self.distance = distance
        self.distanceLabel.text = String(format: "Distance %.2f  meters", self.distance)
        //Pace
        self.updatePace()
    }
    
    // MARK: -  Update Pace
    
    private func updatePace() {
        if CMPedometer.isPaceAvailable() {
            guard let pedometerPace = self.pedometerData.averageActivePace, let pace = pedometerPace as? Double else {
                self.paceLabel.text = "Pace: N/A"
                return
            }
            self.pace = pace
            self.paceLabel.text = String(format: "Avg Pace: %.2f min/mi", self.pace)
            
        } else {
            self.paceLabel.text = String(format: "Avg Pace: %.2f min/mi", self.calculatedPace())
        }
    }
    
    func minutesSeconds(_ seconds: Double) -> String {
        let minute = Int(seconds)/60
        let secondsPart = Int(seconds) % 60
        return String(format: "%02i:%02i", minute, secondsPart)
        
    }
    
    func calculatedPace() -> Double {
        return (self.distance > 0.0) ? self.elepsedSeconds/self.distance : 0.0
    }
}