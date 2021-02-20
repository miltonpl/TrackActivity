//
//  PedometorManager.swift
//  TrackActivity
//
//  Created by Milton Palaguachi on 2/20/21.
//

import Foundation

protocol PedometorManagerDelegate: AnyObject {
    
}

class PedometorManager {
    weak var delegate: PedometorManagerDelegate?
    
}
