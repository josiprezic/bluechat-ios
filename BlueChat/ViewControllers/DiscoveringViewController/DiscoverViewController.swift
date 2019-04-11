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
    
    private final var devices = [BluetoothDevice]()
    private final let tableView = UITableView()
    
    //
    // MARK: - View methods
    //
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.frame = view.frame
        view.addSubview(tableView)
        tableView.delegate = self
        tableView.dataSource = self
        BluetoothService.shared.delegate = self
    }
}

//
// MARK: - EXTENSION - UITableViewDelegate, UITableViewDataSource
//

extension DiscoverViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return devices.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        cell.textLabel?.text = devices[indexPath.row].name
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}

//
// MARK: - EXTENSION - BluetoothServiceDelegate
//

extension DiscoverViewController: BluetoothServiceDelegate {
    func bluetoothService(didChangePeripherals peripherals: [BluetoothDevice]) {
        self.devices = peripherals
        tableView.reloadData()
    }
}


