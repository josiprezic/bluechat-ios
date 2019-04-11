//
//  BluetoothDevice.swift
//  BlueChat
//
//  Created by Korisnik on 11/04/2019.
//  Copyright © 2019 Josip Rezic. All rights reserved.
//

import CoreBluetooth

class BluetoothDevice {
    
    private static var idmax = 0
    
    let id: Int
    let name: String
    let peripheral: CBPeripheral?
    
    init(name: String, peripheral: CBPeripheral? = nil) {
        self.id = BluetoothDevice.idmax
        BluetoothDevice.idmax += 1
        self.name = name
        self.peripheral = peripheral
    }
}
