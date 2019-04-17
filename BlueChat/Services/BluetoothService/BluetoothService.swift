//
//  BluetoothService.swift
//  BlueChat
//
//  Created by Josip Rezic on 11/04/2019.
//  Copyright © 2019 Josip Rezic. All rights reserved.
//

import CoreBluetooth

class BluetoothService: NSObject {
    
    //
    // MARK: - Shared instance
    //
    
    static let shared = BluetoothService()
    
    //
    // MARK: - Private init
    //
    
    private override init() {
        super.init()
        centralManager = CBCentralManager(delegate: self, queue: .main)
        peripheralManager = CBPeripheralManager(delegate: self, queue: nil)
    }
    
    //
    // MARK: - Delegates
    //
    
    weak var deviceDelegate: BluetoothServiceDeviceDelegate?
    weak var messageDelegate: BluetoothServiceMessageDelegate?
    
    //
    // MARK: - Variables
    //
    
    private final var centralManager: CBCentralManager?
    private final var peripheralManager: CBPeripheralManager?
    private final var peripherals: [CBPeripheral] = []
    
    private final let serviceUUID: CBUUID = CBUUID(string: Constants.BluetoothService.bluetoothServiceUUID)
    private final let writeCharacteristicUUID = CBUUID(string: Constants.BluetoothService.bluetoothWriteChatacteristicsUUID) 
    private final let writeCharacteristicProperty: CBCharacteristicProperties = .write
    private final let writeCharacteristicPermission: CBAttributePermissions = .writeable
    private final var writeCharacteristic: CBCharacteristic?
    
    private(set) var localDeviceName = "Unknown Device"
    
    //
    // MARK: - Private methods
    //
    
    private final func startScan() {
        debugPrint("Start scanning...")
        peripherals = []
        let options = [CBCentralManagerScanOptionAllowDuplicatesKey: false]
        centralManager?.scanForPeripherals(withServices: [serviceUUID], options: options)
        // TODO: Add timer
    }
    
    //
    // MARK: - Public methods
    //
    
    final func setUsername(_ username: String) {
        localDeviceName = username
    }
    
    final func connect(toDevice device: BluetoothDevice?) {
        guard let peripheral = device?.peripheral else { return }
        centralManager?.connect(peripheral, options: nil)
    }
    
    final func sendMessage(message: String, toDevice device: BluetoothDevice?) {
        let messageText = message
        guard let data = messageText.data(using: .utf8) else { return }
        guard let wc = writeCharacteristic else { return}
        peripherals[device?.id ?? 0].writeValue(data, for: wc, type: CBCharacteristicWriteType.withResponse)
    }
}

//
// MARK: - Extension - CBCentralManagerDelegate
//

extension BluetoothService: CBCentralManagerDelegate {
    func centralManagerDidUpdateState(_ central: CBCentralManager) {
        guard central.state == .poweredOn else { return }
        startScan()
    }
    
    func centralManager(_ central: CBCentralManager, didDiscover peripheral: CBPeripheral, advertisementData: [String : Any], rssi RSSI: NSNumber) {
        debugPrint("didDiscover peripheral: \(peripheral.name ?? "")")
        peripherals.append(peripheral)
        
        let devices = peripherals.map({ peripheral -> BluetoothDevice in
            return BluetoothDevice(name: peripheral.name ?? "Device", peripheral: peripheral)
        })
        
        deviceDelegate?.bluetoothService(didChangePeripherals: devices)
    }
    
    func centralManager(_ central: CBCentralManager, didConnect peripheral: CBPeripheral) {
        peripheral.delegate = self
        peripheral.discoverServices(nil)
    }
}

//
// MARK: - CBPeripheralManagerDelegate
//

extension BluetoothService: CBPeripheralManagerDelegate {
    func peripheralManagerDidUpdateState(_ peripheral: CBPeripheralManager) {
        guard peripheral.state == .poweredOn else { return }
        let serialService = CBMutableService(type: serviceUUID, primary: true)
        let writeCharacteristics = CBMutableCharacteristic(type: writeCharacteristicUUID, properties: writeCharacteristicProperty, value: nil, permissions: writeCharacteristicPermission)
        serialService.characteristics = [writeCharacteristics]
        peripheralManager?.add(serialService)
        peripheralManager?.startAdvertising([CBAdvertisementDataServiceUUIDsKey:[serviceUUID], CBAdvertisementDataLocalNameKey: localDeviceName])
    }
    
    func peripheralManager(_ peripheral: CBPeripheralManager, didReceiveWrite requests: [CBATTRequest]) {
        requests.forEach { request in
            guard let value = request.value, let messageText = String(data: value, encoding: String.Encoding.utf8) else { return }
            self.peripheralManager?.respond(to: request, withResult: .success)
            messageDelegate?.bluetoothService(didReceiveTextMessage: messageText, fromPeripheral: BluetoothDevice(name: "Some device"))
        }
    }
}

//
// MARK: - Extension - CBPeripheralDelegate
//

extension BluetoothService: CBPeripheralDelegate {
    func peripheral(_ peripheral: CBPeripheral, didDiscoverServices error: Error?) {
        guard let services = peripheral.services else { return }
        services.forEach { service in peripheral.discoverCharacteristics(nil, for: service) }
    }
    
    func peripheral(_ peripheral: CBPeripheral, didDiscoverCharacteristicsFor service: CBService, error: Error?) {
        for characteristic in service.characteristics! {
            let characteristic = characteristic as CBCharacteristic
            guard characteristic.uuid.uuidString.isEqual(writeCharacteristicUUID.uuidString) else { continue }
        
            if writeCharacteristic == nil {
                self.writeCharacteristic = characteristic
            }
        }
    }
}
