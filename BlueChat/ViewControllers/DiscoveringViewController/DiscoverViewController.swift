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
    
    private final let tableView = UITableView()
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
    
    private final func configureTableView() {
        tableView.frame = view.frame
        view.addSubview(tableView)
        tableView.delegate = self
        tableView.dataSource = self
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
