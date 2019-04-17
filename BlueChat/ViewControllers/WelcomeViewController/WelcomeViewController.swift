//
//  WelcomeViewController.swift
//  BlueChat
//
//  Created by Korisnik on 17/04/2019.
//  Copyright © 2019 Josip Rezic. All rights reserved.
//

import UIKit
import SnapKit

class WelcomeViewController: UIViewController {
    
    //
    // MARK: - Views
    //
    
    private final lazy var userInfoContainerView = UIView()
    private final lazy var btnUserPhoto = UIButton()
    private final lazy var tfUsername = UITextField()
    private final lazy var btnNext = UIButton()
    
    //
    // MARK: - View methods
    //
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        configureView()
    }
    
    //
    // MARK: - UI setup methods
    //
    
    private final func configureView() {
        view.backgroundColor = .black
        configureUserInfoContainerView()
    }
    
    private final func configureUserInfoContainerView() {
        view.addSubview(userInfoContainerView)
        userInfoContainerView.snp.makeConstraints { make in
            make.width.equalToSuperview()
            make.height.equalTo(270)
            make.center.equalToSuperview()
        }
        userInfoContainerView.backgroundColor = view.backgroundColor
        configureBtnUserPhoto()
        configureTfUsername()
        configureBtnNext()
    }
    
    private final func configureBtnUserPhoto() {
        userInfoContainerView.addSubview(btnUserPhoto)
        let btnSize: CGFloat = 200
        btnUserPhoto.clipsToBounds = true
        btnUserPhoto.snp.makeConstraints { make in
            make.size.height.equalTo(btnSize)
            make.size.width.equalTo(btnSize)
            make.centerX.equalToSuperview()
            make.top.equalToSuperview()
        }
        btnUserPhoto.backgroundColor = .gray
        btnUserPhoto.setImage(#imageLiteral(resourceName: "user_default"), for: .normal)
        btnUserPhoto.layer.cornerRadius = btnSize/2
    }
    
    private final func configureTfUsername() {
        userInfoContainerView.addSubview(tfUsername)
        tfUsername.snp.makeConstraints { make in
            make.centerX.equalToSuperview().offset(-15)
            make.bottom.equalTo(userInfoContainerView.snp.bottom)
            make.width.equalTo(btnUserPhoto.snp.width)
            make.height.equalTo(30)
        }
        tfUsername.backgroundColor = .white
        tfUsername.placeholder = Constants.WelcomeViewController.username
        
    }
    
    private final func configureBtnNext() {
        userInfoContainerView.addSubview(btnNext)
        btnNext.backgroundColor = #colorLiteral(red: 0.1724731464, green: 0.8942734772, blue: 0.1693705928, alpha: 1)
        btnNext.setTitle("->", for: .normal)
        btnNext.snp.makeConstraints { make in
            make.width.equalTo(30)
            make.height.equalTo(30)
            make.left.equalTo(tfUsername.snp.right)
            make.top.equalTo(tfUsername.snp.top)
        }
        btnNext.addTarget(self, action: #selector(btnNextPressed), for: .touchUpInside)
    }
    
    //
    // MARK: - Methods
    //
    
    @objc private final func btnNextPressed() {
        guard validateUsername() else { return }
        view.endEditing(true)
        BluetoothService.shared.setUsername(tfUsername.text ?? "Unknown")
        navigationController?.pushViewController(DiscoverViewController(), animated: true)
    }
    
    private final func validateUsername() -> Bool {
        guard !(tfUsername.text?.isEmpty ?? true) else { return false }
        return true
    }
}
