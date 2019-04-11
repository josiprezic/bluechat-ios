//
//  DiscoverViewController.swift
//  BlueChat
//
//  Created by Korisnik on 11/04/2019.
//  Copyright © 2019 Josip Rezic. All rights reserved.
//

import UIKit
import CoreBluetooth

class DiscoverViewController: UIViewController {
    
    //
    // MARK: - Variables
    //
    
    var centralManager: CBCentralManager?
    
    //
    // MARK: - View methods
    //
    
    override func viewDidLoad() {
        super.viewDidLoad()
        centralManager = CBCentralManager(delegate: self, queue: nil)
    }
}

//
// MARK: - Extension - CBCentralManagerDelegate
//

extension DiscoverViewController: CBCentralManagerDelegate {
    func centralManagerDidUpdateState(_ central: CBCentralManager) {
        debugPrint("centralManagerDidUpdateState:")
        switch central.state {
        case .unknown:
            debugPrint(".unknown")
        case .resetting:
            debugPrint(".resetting")
        case .unsupported:
            debugPrint(".unsupported")
        case .unauthorized:
            debugPrint(".unauthorized")
        case .poweredOff:
            debugPrint(".poweredOff")
        case .poweredOn:
            debugPrint(".poweredOn")
        @unknown default:
            debugPrint(".default")
        }
    }
}

//
// MARK: - Extension - CBPeripheralManagerDelegate
//

extension DiscoverViewController: CBPeripheralManagerDelegate {
    func peripheralManagerDidUpdateState(_ peripheral: CBPeripheralManager) {
        debugPrint("peripheralManagerDidUpdateState:")
        switch peripheral.state {
        case .unknown:
            debugPrint("unknown")
        case .resetting:
            debugPrint("resetting")
        case .unsupported:
            debugPrint("unsupported")
        case .unauthorized:
            debugPrint("unauthorized")
        case .poweredOff:
            debugPrint("poweredOff")
        case .poweredOn:
            debugPrint("poweredOn")
        @unknown default:
            debugPrint("default")
        }
    }
}


