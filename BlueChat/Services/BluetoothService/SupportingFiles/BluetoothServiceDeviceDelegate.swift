//
//  BluetoothServiceDeviceDelegate.swift
//  BlueChat
//
//  Created by Josip Rezic on 11/04/2019.
//  Copyright © 2019 Josip Rezic. All rights reserved.
//

protocol BluetoothServiceDeviceDelegate: class {
    func bluetoothService(didChangePeripherals peripherals: [BluetoothDevice])
}
