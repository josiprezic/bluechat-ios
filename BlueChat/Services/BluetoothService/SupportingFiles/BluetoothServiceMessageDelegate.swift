//
//  BluetoothServiceMessageDelegate.swift
//  BlueChat
//
//  Created by Josip Rezic on 11/04/2019.
//  Copyright © 2019 Josip Rezic. All rights reserved.
//

protocol BluetoothServiceMessageDelegate: class {
    func bluetoothService(didReceiveTextMessage message: String, fromPeripheral peripheral: BluetoothDevice)
}
