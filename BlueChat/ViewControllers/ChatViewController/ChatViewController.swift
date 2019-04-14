//
//  ChatViewController.swift
//  BlueChat
//
//  Created by Josip Rezic on 11/04/2019.
//  Copyright © 2019 Josip Rezic. All rights reserved.
//

import UIKit
import SnapKit

class ChatViewController: UIViewController {

    var device: BluetoothDevice?
    var messages = [String]()
    
    let tableView = UITableView()
    let newMesssageContainer = UIView()
    let btnSend = UIButton()
    let tfMessage = UITextField()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        
        BluetoothService.shared.messageDelegate = self
        BluetoothService.shared.connect(toDevice: device)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        configureView()
    }
    
    private final func configureView() {
        title = device?.name ?? "Unknown device"
        configureTableView()
        configureNewMessageContainer()
    }
    
    private final func configureTableView() {
        view.addSubview(tableView)
        tableView.snp.makeConstraints { make in
            [make.top, make.left, make.right].forEach { c in c.equalToSuperview() }
            make.bottom.equalToSuperview().offset(-50)
        }
    }
    
    private final func configureNewMessageContainer() {
        view.addSubview(newMesssageContainer)
        view.backgroundColor = .green
        newMesssageContainer.snp.makeConstraints { make in
            [make.left, make.bottom, make.right].forEach { c in c.equalToSuperview() }
            make.top.equalTo(tableView.snp.bottom)
        }
        configureSendMessageButton()
        configureMessageTextField()
        
    }
    
    private final func configureSendMessageButton() {
        newMesssageContainer.addSubview(btnSend)
        btnSend.backgroundColor = .blue
        btnSend.setTitle("Send", for: .normal)
        btnSend.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(5)
            make.right.equalToSuperview().offset(-5)
            make.bottom.equalToSuperview().offset(-5)
            make.width.equalTo(70)
        }
    }
    
    private final func configureMessageTextField() {
        newMesssageContainer.addSubview(tfMessage)
        tfMessage.backgroundColor = .red
        tfMessage.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(5)
            make.bottom.equalToSuperview().offset(-5)
            make.left.equalToSuperview().offset(5)
            make.right.equalTo(btnSend.snp.left).offset(-5)
        }
    }

    
    
    @IBAction func tempButtonPressed(_ sender: Any) {
        BluetoothService.shared.sendMessage(message: "Fooo", toDevice: device)
    }
}

extension ChatViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return messages.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        cell.textLabel?.text = messages[indexPath.row]
        return cell
    }
}

extension ChatViewController: BluetoothServiceMessageDelegate {
    func bluetoothService(didReceiveTextMessage message: String, fromPeripheral peripheral: BluetoothDevice) {
        messages.append(message)
        tableView.reloadData()
    }
}
