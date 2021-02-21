//
//  ViewController.swift
//  CoreMotionPedometer
//
//  Created by Milton Palaguachi on 2/11/21.
//

import UIKit
import CoreMotion

class ViewController: UIViewController {
    
    @IBOutlet private weak var statusLabel: UILabel!
    @IBOutlet private weak var stepsLabel: UILabel!
    @IBOutlet private weak var distanceLabel: UILabel!
    @IBOutlet private weak var paceLabel: UILabel!
    @IBOutlet private weak var startStopRedometer: UIButton!
    
    private lazy var pedometerHandler = PedometerHandler()

   // MARK: - View Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.pedometerHandler.delegate = self
    }
    
    // MARK: - IBAction StartStopPedometer
    @IBAction func startStopPedometer(_ sender: UIButton) {
        self.pedometerHandler.startStopPedometer(sender)
    }
  
}

// MARK: - Pedometor Handler Delegate

extension ViewController: PedometorHandlerDelegate {
    
    func paceLabel(_ text: String) {
        self.paceLabel.text = text
    }
    
    func stepsLabel(_ text: String) {
        self.stepsLabel.text = text
    }
    
    func distanceLabel(_ text: String) {
        self.distanceLabel.text = text
    }
    
    func statusLabel(_ text: String) {
        self.statusLabel.text = text
    }
}
