//
//  DiscoverViewController.swift
//  BlueChat
//
//  Created by Josip Rezic on 11/04/2019.
//  Copyright © 2019 Josip Rezic. All rights reserved.
//

import UIKit
import CoreBluetooth

class DiscoverViewController: UITableViewController {
    
    //
    // MARK: - Variables
    //
    
    private final var devices = [BluetoothDevice]()
    
    //
    // MARK: - View methods
    //
    
    override func viewDidLoad() {
        super.viewDidLoad()
        BluetoothService.shared.deviceDelegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        configureView()
    }
    
    //
    // MARK: - Methods
    //
    
    private final func configureView() {
        configureNavigationBar()
        configureTableView()
    }
    
    private final func configureNavigationBar() {
        title = Constants.DiscoverViewController.title
    }
    
    private final func configureTableView() {}
}

//
// MARK: - EXTENSION - UITableViewDelegate, UITableViewDataSource
//

extension DiscoverViewController {
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return devices.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        cell.textLabel?.text = devices[indexPath.row].name
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let vc = ChatViewController.fromStoryboard()
        vc.device = devices[indexPath.row]
        navigationController?.pushViewController(vc, animated: true)
    }
}

//
// MARK: - EXTENSION - BluetoothServiceDelegate
//

extension DiscoverViewController: BluetoothServiceDeviceDelegate {
    func bluetoothService(didChangePeripherals peripherals: [BluetoothDevice]) {
        self.devices = peripherals
        tableView.reloadData()
    }
}
